import 'package:burger/domain/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  Future<bool> addInCart(CartItemModel item) async {
    print(
      "addInCart called for itemId: ${item.itemId}, userId: ${item.userId}",
    );
    print(
      "Item details -> name: ${item.name}, price: ${item.price}, quantity: ${item.quantity}",
    );
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(item.userId)
          .collection('cart')
          .doc(item.itemId);
      final doc = await cartRef.get(const GetOptions(source: Source.server));
      print(
        "Writing document at path: users/${item.userId}/cart/${item.itemId}",
      );

      if (doc.exists) {
        final data = doc.data();
        final currentQty = (data != null && data['quantity'] is int)
            ? data['quantity'] as int
            : (data != null && data['quantity'] is num)
            ? (data['quantity'] as num).toInt()
            : 0;
        await cartRef.update({'quantity': currentQty + item.quantity});
        print("UPDATE SUCCESS!");
        return true;
      } else {
        await cartRef.set({
          'itemId': item.itemId,
          'partnerId': item.partnerId,
          'name': item.name,
          'price': item.price,
          'image': item.image,
          'quantity': item.quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
        print("WRITE SUCCESS!");
        return true;
      }
    } catch (e, stack) {
      print("Error adding to cart: $e");
      print("STACKTRACE:");
      print(stack);
      return false;
    }
  }

  Stream<List<CartItemModel>> getCartStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return CartItemModel(
              userId: userId,
              itemId: data['itemId'],
              partnerId: data['partnerId'],
              name: data['name'],
              price: data['price'],
              image: data['image'],
              quantity: data['quantity'],
            );
          }).toList();
        });
  }

  Future<void> deleteCartItem(String id) async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .doc(id);

      await cartRef.delete();
      print("DELETE SUCCESS");
    } catch (e, stack) {
      print("Error deleting cart item: $e");
      print(stack);
    }
  }
}
