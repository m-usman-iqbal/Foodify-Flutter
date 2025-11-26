import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:burger/domain/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderServices {
  Future<bool> postOrder(OrderModel order) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Generate order document with auto ID for user
      final userOrderRef = firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc();

      final orderId = userOrderRef.id;

      // Same orderId for partner
      final partnerOrderRef = firestore
          .collection('partners')
          .doc(order.partnerId)
          .collection('orders')
          .doc(orderId);

      // Convert model to map
      final orderData = order.toMap(orderId);

      // Write both using batch
      final batch = firestore.batch();
      batch.set(userOrderRef, orderData);
      batch.set(partnerOrderRef, orderData);

      await batch.commit();

      return true; // SUCCESS
    } catch (e, stack) {
      print("❌ Order Post Error: $e");
      print(stack);
      return false; // FAILED
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get();

      final orders = querySnapshot.docs.map((doc) {
        return {
          ...doc.data(), // Spread operator -> includes all fields of the order
        };
      }).toList();

      return orders;
    } catch (e) {
      print("❌ Error fetching orders: $e");
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> fetchPartnerOrders(String partnerId) {
    try {
      final ordersCollection = FirebaseFirestore.instance
          .collection('partners')
          .doc(partnerId)
          .collection('orders');

      return ordersCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("❌ Error fetching orders: $e");
      return const Stream.empty();
    }
  }

  Future<void> addReview(
    String review,
    String orderId,
    String partnerId,
    List<Map<String, dynamic>> order,
  ) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      final path1 = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(orderId);
      batch.update(path1, {'review': review});
      final path2 = FirebaseFirestore.instance
          .collection('partners')
          .doc(partnerId)
          .collection('orders')
          .doc(orderId);
      batch.update(path2, {'review': review});

      final reviewsCollection = FirebaseFirestore.instance
          .collection('partners')
          .doc(partnerId)
          .collection('reviews');

      final newReviewDoc = reviewsCollection.doc();

      batch.set(newReviewDoc, {
        'orderId': orderId,
        'message': review,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'order': order,
      });
      await batch.commit();
    } catch (e) {
      print('e');
    }
  }

  Future<List<Map<String, dynamic>>> getReviews(String partnerId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('partners')
          .doc(partnerId)
          .collection('reviews')
          .get();

      final List<Map<String, dynamic>> reviews = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data();
          final userId = data['userId'];

          // Fetch user data
          final userRef = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          final username = userRef.data()?['username'] ?? '';
          final image = userRef.data()?['imagePath'] ?? '';

          return {
            'message': data['message'] ?? '',
            'createdAt': data['createdAt'] ?? null,
            'order': data['order'] ?? [],
            'name': username,
            'image': image,
          };
        }),
      );

      return reviews;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
