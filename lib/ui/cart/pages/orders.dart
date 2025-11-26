// import 'package:burger/bloc/orders_bloc/orders_bloc.dart';
// import 'package:burger/data/repositories/order_repository.dart';
// import 'package:burger/data/services/order_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Orders extends StatefulWidget {
//   const Orders({super.key});

//   @override
//   State<Orders> createState() => _OrdersState();
// }

// class _OrdersState extends State<Orders> {
//   TextEditingController reviewController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     context.read<OrdersBloc>().add(FetchUserOrdersEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Orders")),
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
//                             Text("Status : "),
//                             Text(
//                               " ${order['status']}",
//                               style: TextStyle(
//                                 color: order['status'] == 'Completed'
//                                     ? Colors.green
//                                     : Colors.red,
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
//                         SizedBox(height: 8),

//                         order['review'] == null || order['review'].isEmpty
//                             ? Container(
//                                 padding: EdgeInsets.all(
//                                   8,
//                                 ), // optional padding around the container
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors
//                                             .amber[100], // very light amber
//                                         borderRadius: BorderRadius.circular(15),
//                                         border: Border.all(
//                                           color: Colors.orange,
//                                           width: 2,
//                                         ),
//                                       ),
//                                       child: TextField(
//                                         controller: reviewController,
//                                         maxLength: 200,
//                                         maxLines: 3,
//                                         decoration: InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(
//                                             vertical: 16,
//                                             horizontal: 12,
//                                           ),
//                                           border: InputBorder.none,
//                                           hintText: "Write your review here...",
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Color(0xffEF9F27),
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         OrderRepository(
//                                           service: OrderServices(),
//                                         ).addReviw(
//                                           reviewController.text,
//                                           order['orderId'],
//                                           order['partnerId'],
//                                         );
//                                         context.read<OrdersBloc>().add(
//                                           FetchUserOrdersEvent(),
//                                         );
//                                       },
//                                       child: Text('Add review'),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Center(
//                                 child: SizedBox(
//                                   child: Text(
//                                     'Review already added',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ), // if review exists, show nothing
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return Center(child: Text("No Orders Found"));
//         },
//       ),
//     );
//   }
// }

import 'package:burger/bloc/orders_bloc/orders_bloc.dart';
import 'package:burger/data/repositories/order_repository.dart';
import 'package:burger/data/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final TextEditingController _reviewController = TextEditingController();
  final OrderRepository _orderRepository = OrderRepository(
    service: OrderServices(),
  );

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(FetchUserOrdersEvent());
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.day}-${dt.month}-${dt.year} • ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

  Color _getStatusColor(String status) =>
      status == 'Completed' ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), elevation: 0),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersLoaded) {
            final orders = state.orders;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderCard(
                order: orders[index],
                orderRepository: _orderRepository,
                reviewController: _reviewController,
                formatDateTime: _formatDateTime,
                getStatusColor: _getStatusColor,
                bloc: context.read<OrdersBloc>(),
              ),
            );
          }

          return const Center(child: Text('No Orders Found'));
        },
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Map order;
  final OrderRepository orderRepository;
  final TextEditingController reviewController;
  final String Function(DateTime) formatDateTime;
  final Color Function(String) getStatusColor;
  final OrdersBloc bloc;

  const _OrderCard({
    required this.order,
    required this.orderRepository,
    required this.reviewController,
    required this.formatDateTime,
    required this.getStatusColor,
    required this.bloc,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _showReviewForm = false;
  late List<Map<String, dynamic>> orderItems;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    List itemInfo = order['itemInfo'] ?? [];

    orderItems = itemInfo.map((item) {
      return {'name': item['name'], 'quantity': item['quantity']};
    }).toList();

    final hasReview =
        order['review'] != null && (order['review'] as String).isNotEmpty;
    final items = order['itemInfo'] ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.formatDateTime(order['createdAt'].toDate()),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Chip(
                  label: Text(order['status']),
                  backgroundColor: widget
                      .getStatusColor(order['status'])
                      .withAlpha(51),
                  labelStyle: TextStyle(
                    color: widget.getStatusColor(order['status']),
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Items
            Text('Items', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...items.map<Widget>(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['name']} x${item['quantity']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Rs ${item['price'] * item['quantity']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rs ${order['totalPrice']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Review section
            if (!hasReview) ...[
              GestureDetector(
                onTap: () => setState(() => _showReviewForm = !_showReviewForm),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xffEF9F27),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _showReviewForm ? 'Hide Review' : 'Add Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (_showReviewForm) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: widget.reviewController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'Write your review...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEF9F27),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      widget.orderRepository.addReviw(
                        widget.reviewController.text,
                        order['orderId'],
                        order['partnerId'],
                        orderItems,
                      );
                      widget.bloc.add(FetchUserOrdersEvent());
                      widget.reviewController.clear();
                      setState(() => _showReviewForm = false);
                    },
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ Review submitted',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
