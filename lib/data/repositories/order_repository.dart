import 'package:burger/data/services/order_services.dart';
import 'package:burger/domain/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderRepository {
  final OrderServices service;
  OrderRepository({required this.service});

  Future<bool> post(OrderModel order) async {
    return await service.postOrder(order);
  }

  Future<List<Map<String, dynamic>>> get() async {
    return await service.fetchUserOrders();
  }

  Future<List<Map<String, dynamic>>> getReviews(String partnerId) async {
    return await service.getReviews(partnerId);
  }

  Future<void> addReviw(
    String review,
    String orderId,
    String partnerId,
    List<Map<String, dynamic>> order,
  ) async {
    return await service.addReview(review, orderId, partnerId, order);
  }

  Stream<List<Map<String, dynamic>>> getPartnerOrders(String partnerId) {
    return service.fetchPartnerOrders(partnerId);
  }
}
