// import 'package:burger/bloc/orders_bloc/orders_bloc.dart';
// import 'package:burger/data/repositories/change_status_repository.dart';
// import 'package:burger/data/services/change_status_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PartnerOrders extends StatefulWidget {
//   const PartnerOrders({super.key});

//   @override
//   State<PartnerOrders> createState() => _OrdersState();
// }

// class _OrdersState extends State<PartnerOrders> {
//   late String partnerId;
//   Future<String> fetchPartnerId() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();

//     final pid = doc.data()?['restaurantId'];
//     partnerId = pid;
//     return pid;
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchPartnerId().then((pid) {
//       if (!mounted) return; // safe use of context

//       context.read<OrdersBloc>().add(
//         StartListeningPartnerOrdersEvent(partnerId: pid),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My PartnerOrders")),
//       body: BlocBuilder<OrdersBloc, OrdersState>(
//         builder: (context, state) {
//           if (state is OrdersLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (state is OrdersLoaded) {
//             final orders = state.orders;

//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];

//                 DateTime dt = order['createdAt'].toDate();
//                 String date = "${dt.day}-${dt.month}-${dt.year}";
//                 String time =
//                     "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";

//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.amber[50],
//                     border: Border.all(
//                       color: Colors.orange, // border color
//                       width: 2, // border width
//                     ), // very faint amber
//                   ),
//                   margin: EdgeInsets.all(12),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Date + Time
//                         Text(
//                           "Ordered: $date at $time",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),

//                         SizedBox(height: 8),

//                         Row(
//                           children: [
//                             Row(
//                               children: [
//                                 Text('Status : '),
//                                 Text(
//                                   "${order['status']} ",
//                                   style: TextStyle(
//                                     color: order['status'] == 'Completed'
//                                         ? Colors.green
//                                         : Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Icon(
//                               order['status'] == 'Completed'
//                                   ? Icons.done
//                                   : Icons.hourglass_top,
//                               color: order['status'] == 'Completed'
//                                   ? Colors.green
//                                   : Colors.red[200],
//                             ),
//                             SizedBox(width: 20),
//                             GestureDetector(
//                               onTap: () {
//                                 ChangeStatusRepository(
//                                   services: ChangeStatusServices(),
//                                 ).updateStatus(
//                                   order['orderId'],
//                                   order['userId'],
//                                   order['partnerId'],
//                                 );
//                                 fetchPartnerId();

//                                 fetchPartnerId().then((pid) {
//                                   if (!mounted) return; // safe use of context

//                                   context.read<OrdersBloc>().add(
//                                     FetchUserOrdersEvent(),
//                                   );
//                                 });
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: Color(0xffEF9F27),
//                                 ),
//                                 padding: EdgeInsets.all(6),
//                                 child: Center(
//                                   child: Text(
//                                     'change',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: 8),

//                         // Items list
//                         Text(
//                           "Items:",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         ...(order['itemInfo'] != null
//                             ? order['itemInfo'].map<Widget>((item) {
//                                 return Text(
//                                   "- ${item['name']} (x${item['quantity']} ${item['price']}) = ${item['price'] * item['quantity']}",
//                                 );
//                               }).toList()
//                             : [Text("No items")]),
//                         SizedBox(height: 8),

//                         Text("Total: Rs ${order['totalPrice']}"),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return Center(child: Text("No PartnerOrders Found"));
//         },
//       ),
//     );
//   }
// }

import 'package:burger/bloc/orders_bloc/orders_bloc.dart';
import 'package:burger/data/repositories/change_status_repository.dart';
import 'package:burger/data/services/change_status_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartnerOrders extends StatefulWidget {
  const PartnerOrders({super.key});

  @override
  State<PartnerOrders> createState() => _OrdersState();
}

class _OrdersState extends State<PartnerOrders> {
  late String partnerId;

  Future<String> fetchPartnerId() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    partnerId = doc.data()?['restaurantId'] ?? '';
    return partnerId;
  }

  @override
  void initState() {
    super.initState();
    fetchPartnerId().then((pid) {
      if (!mounted) return;
      context.read<OrdersBloc>().add(
        StartListeningPartnerOrdersEvent(partnerId: pid),
      );
    });
  }

  void _updateOrderStatus(Map<String, dynamic> order) {
    ChangeStatusRepository(
      services: ChangeStatusServices(),
    ).updateStatus(order['orderId'], order['userId'], order['partnerId']);
    fetchPartnerId().then((pid) {
      if (!mounted) return;
      context.read<OrdersBloc>().add(FetchUserOrdersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Partner Orders")),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text("No Partner Orders Found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _OrderCard(
                  order: orders[index],
                  onStatusChange: () => _updateOrderStatus(orders[index]),
                );
              },
            );
          }

          return const Center(child: Text("No Partner Orders Found"));
        },
      ),
    );
  }
}

// <CHANGE> Extracted order card into separate widget for cleaner code
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onStatusChange;

  const _OrderCard({required this.order, required this.onStatusChange});

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return "N/A";
    DateTime dt = timestamp.toDate();
    return "${dt.day}-${dt.month}-${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  bool get _isCompleted => order['status'] == 'Completed';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Date + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(order['createdAt']),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isCompleted ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isCompleted ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCompleted ? Icons.check_circle : Icons.hourglass_top,
                        size: 16,
                        color: _isCompleted ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order['status'] ?? 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Items List
            const Text(
              "Items",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ...(order['itemInfo'] as List?)?.map<Widget>((item) {
                  final price = (item['price'] as num).toDouble();
                  final quantity = item['quantity'] as int;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "${item['name']} × $quantity = Rs ${(price * quantity).toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList() ??
                [const Text("No items")],
            const SizedBox(height: 12),

            // Total + Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: Rs ${order['totalPrice']}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: onStatusChange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEF9F27),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Update Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
