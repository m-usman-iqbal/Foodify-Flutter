import 'package:burger/data/services/cart_services.dart';
import 'package:burger/domain/models/cart_item_model.dart';

class CartRepository {
  final CartServices service;

  CartRepository({required this.service});

  Future<bool> addCartRepo(CartItemModel cartItem) async {
    return await service.addInCart(cartItem);
  }

  Future<void> deleteItem(String id) async {
    await service.deleteCartItem(id);
  }

  Stream<List<CartItemModel>> getCartItems(String userId) {
    return service.getCartStream(userId);
  }
}
