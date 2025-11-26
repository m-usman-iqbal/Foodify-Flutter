import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:burger/data/repositories/cart_repository.dart';
import 'package:burger/domain/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;
  StreamSubscription<List<CartItemModel>>? _cartSubscription;

  CartBloc({required this.repository}) : super(CartInitial()) {
    // Add to cart
    on<AddToCartEvent>((event, emit) async {
      try {
        await repository.addCartRepo(event.item);
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    // Load / listen to cart
    on<LoadCartEvent>((event, emit) {
      emit(CartLoading());
      _cartSubscription?.cancel();
      _cartSubscription = repository
          .getCartItems(event.userId)
          .listen(
            (items) {
              add(CartUpdatedEvent(items));
            },
            onError: (error) {
              emit(CartError(error.toString()));
            },
          );
    });

    // Update state when cart items change
    on<CartUpdatedEvent>((event, emit) {
      emit(CartLoaded(event.items));
    });

    on<DeleteItem>((event, emit) async {
      try {
        await repository.deleteItem(event.id);
        print("Item deleted, stream will refresh automatically");
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<ClearCartEvent>((event, emit) async {
      await _cartSubscription?.cancel();

      emit(CartLoaded([]));
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart');

        final snapshot = await cartRef.get();
        final batch = FirebaseFirestore.instance.batch();

        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      } catch (e) {
        print("Error clearing Firestore cart: $e");
      }
    });
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
