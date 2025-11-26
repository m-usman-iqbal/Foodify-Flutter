import 'package:burger/bloc/cart_bloc/cart_bloc.dart';
import 'package:burger/data/repositories/order_repository.dart';
import 'package:burger/data/services/order_services.dart';
import 'package:burger/domain/models/cart_item_model.dart';
import 'package:burger/domain/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItem;
  const CheckoutScreen({super.key, required this.cartItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<void> getAddress() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final address = doc.data()?['address'];
      setState(() {
        address1 = address;
      });
      print(address);
    } catch (e) {}
  }

  num subtotal = 0;
  int delivery = 200;
  num total = 0;
  String address1 = '';
  late String partnerId;
  late List<Map<String, dynamic>> itemInfo;

  void initState() {
    super.initState();
    getAddress();

    // Calculate subtotal once
    for (var item in widget.cartItem) {
      subtotal += item.quantity * item.price;
    }

    total = subtotal + delivery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Confirm order',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 185,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Delivery to',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity, // full width
                  height: 1, // 1 pixel tall
                  color: Color(0xFFF4F5F7), // your color
                ),
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset('assets/mini.png'),
                      ),
                      SizedBox(
                        height: 80,
                        width: 210,
                        child: Text(
                          '$address1',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: Text(
                      'Your order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity, // full width
                    height: 1, // 1 pixel tall
                    color: Color(0xFFF4F5F7), // your color
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: widget.cartItem.length, // number of items
                        itemBuilder: (context, index) {
                          final item = widget.cartItem[index];
                          return SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),

                                    child: Image.asset(
                                      // item['image'],
                                      'assets/${item.image}',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                SizedBox(
                                  height: 80,
                                  // width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Quantity : ${item.quantity}'),
                                      Text(
                                        '${item.price * item.quantity} Rs',
                                        style: TextStyle(
                                          color: Color(0xFFEF9F27),
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
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 33,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$subtotal/-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity, // full width
                          height: 1, // 1 pixel tall
                          color: Color(0xFFF4F5F7), // your color
                        ),
                        SizedBox(
                          height: 33,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$delivery/-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity, // full width
                          height: 1, // 1 pixel tall
                          color: Color(0xFFF4F5F7), // your color
                        ),
                        SizedBox(
                          height: 33,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$total/-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final partnerId = widget.cartItem[0].partnerId;
                final itemInfo = widget.cartItem
                    .map(
                      (item) => {
                        'id': item.itemId,
                        'quantity': item.quantity,
                        'price': item.price,
                        'name': item.name,
                      },
                    )
                    .toList();

                final order = OrderModel(
                  partnerId: partnerId,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  totalPrice: total,
                  itemInfo: itemInfo,
                  status: 'Pending',
                );

                final success = await OrderRepository(
                  service: OrderServices(),
                ).post(order);

                if (success) {
                  // Clear cart or show success
                  context.read<CartBloc>().add(ClearCartEvent());
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('order confirmed'),
                      content: const Text(
                        "Thankyou for ordering, enjoy your meal",
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () => {
                              Navigator.pop(context),
                              Navigator.pop(context),
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xFFEF9F27),
                              ),
                              padding: EdgeInsets.all(10),
                              height: 40,
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  print("✅ Order posted successfully");
                } else {
                  // Show error
                  print("❌ Failed to post order");
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF9F27),
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm order',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
