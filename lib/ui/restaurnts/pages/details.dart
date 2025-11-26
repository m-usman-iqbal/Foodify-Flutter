import 'package:burger/bloc/cart_bloc/cart_bloc.dart';
import 'package:burger/data/repositories/cart_repository.dart';
import 'package:burger/data/services/cart_services.dart';
import 'package:burger/domain/models/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Details extends StatefulWidget {
  final dynamic item;
  // final String PartnerId;

  const Details({super.key, required this.item});

  @override
  State<Details> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(
      LoadCartEvent(FirebaseAuth.instance.currentUser!.uid),
    );
  }

  // Sizes and selected size
  final List<String> sizes = ['S', 'M', 'L'];
  String selectedSize = 'M';

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Quantity
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFFEF9F27);
    final buttonBgColor = const Color(0xFFFFF0B3);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          String? cartPartnerId;
          if (state is CartLoaded) {
            final cartItems = state.items;

            if (cartItems.isNotEmpty) {
              final item = cartItems[0];
              cartPartnerId = item.partnerId;
            } else {
              cartPartnerId = null; // cart is empty
            }
          }

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Back arrow
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: baseColor, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  widget.item['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Description
                Text(
                  widget.item['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    'assets/${widget.item['imagePath']}', // replace with your image
                    // replace with your image
                    height: 243,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 57),

                // Quantity selector
                SizedBox(
                  width: 152,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Minus
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: buttonBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.remove, color: baseColor),
                        ),
                      ),

                      // Quantity number
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Plus
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: buttonBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: baseColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom section: Price and order button
                Container(
                  height: 102,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '\$12.99', // hardcoded price
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: baseColor,
                            ),
                          ),
                        ],
                      ),

                      (cartPartnerId == null ||
                              cartPartnerId == widget.item['partnerId'])
                          ?
                            // Place order button
                            ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFEF9F27),
                                      ),
                                    ),
                                  ),
                                );
                                final item = CartItemModel(
                                  image: widget.item['imagePath'],
                                  itemId: widget.item['id'],
                                  name: widget.item['title'],
                                  partnerId: widget.item['partnerId'],
                                  price: widget.item['price'],
                                  userId: uid,
                                  quantity: quantity,
                                );
                                // context.read<CartBloc>().add(AddToCartEvent(item));
                                final success = await CartRepository(
                                  service: CartServices(),
                                ).addCartRepo(item);
                                Navigator.pop(context);
                                if (success) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Added to cart'),
                                      content: const Text(
                                        "Go to cart to confirm order",
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                            onPressed: () => {
                                              Navigator.pop(context),
                                              Navigator.pop(context),
                                              Navigator.pop(context),
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Color(0xFFEF9F27),
                                              ),
                                              padding: EdgeInsets.all(10),
                                              height: 40,
                                              child: Text(
                                                'Go to cart',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: baseColor,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red[400],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Clear cart first ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.lock, color: Colors.white),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
