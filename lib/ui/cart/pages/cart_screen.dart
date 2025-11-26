import 'package:burger/bloc/cart_bloc/cart_bloc.dart';
import 'package:burger/domain/models/cart_item_model.dart';
import 'package:burger/ui/cart/pages/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  final String userId; // pass the current user's UID

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItemModel> cartItems1;
  @override
  Widget build(BuildContext context) {
    // Load the cart when screen opens
    context.read<CartBloc>().add(LoadCartEvent(widget.userId));

    return Scaffold(
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.items.isNotEmpty) {
            cartItems1 = state.items; // update your local list
            return SizedBox(
              width: 80,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckoutScreen(cartItem: cartItems1),
                    ),
                  );
                },
                backgroundColor: const Color(0xFFEF9F27),
                foregroundColor: Colors.white,
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          return const SizedBox.shrink(); // hide button if cart is empty
        },
      ),

      appBar: AppBar(title: const Text("My Cart"), centerTitle: true),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cartItems = state.items;
            cartItems1 = cartItems;

            if (cartItems.isEmpty) {
              return const Center(child: Text("Your cart is empty"));
            }

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/${item.image}', // your image path
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Quantity: ${item.quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${item.price}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Trigger delete event
                            context.read<CartBloc>().add(
                              DeleteItem(item.itemId),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CartError) {
            return Center(child: Text("Error: ${state.error}"));
          }

          return const SizedBox(); // empty state
        },
      ),
    );
  }
}
