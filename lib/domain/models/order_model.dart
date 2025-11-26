import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String partnerId;
  final String userId;
  final num totalPrice;
  final String status;

  final List<Map<String, dynamic>> itemInfo;

  OrderModel({
    required this.partnerId,
    required this.userId,
    required this.totalPrice,
    required this.itemInfo,
    required this.status,
  });

  Map<String, dynamic> toMap(String orderId) {
    return {
      'orderId': orderId,
      'partnerId': partnerId,
      'userId': userId,
      'totalPrice': totalPrice,
      'itemInfo': itemInfo,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
