class CartItemModel {
  final String userId;
  final String partnerId;
  final String itemId;
  final String name;
  final int price;
  final String image;
  final int quantity;

  CartItemModel({
    required this.image,
    required this.itemId,
    required this.name,
    required this.partnerId,
    required this.price,
    required this.userId,
    required this.quantity,
  });
}
