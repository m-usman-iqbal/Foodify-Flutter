part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// Add item to cart
class AddToCartEvent extends CartEvent {
  final CartItemModel item;
  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

// Fetch / listen to cart stream
class LoadCartEvent extends CartEvent {
  final String userId;
  const LoadCartEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteItem extends CartEvent {
  final String id;
  const DeleteItem(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearCartEvent extends CartEvent {}

// Internal event: update bloc state when new cart items arrive
class CartUpdatedEvent extends CartEvent {
  final List<CartItemModel> items;
  const CartUpdatedEvent(this.items);

  @override
  List<Object?> get props => [items];
}
