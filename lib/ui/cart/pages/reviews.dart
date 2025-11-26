import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:burger/bloc/reviews_bloc/reviews_bloc.dart';

class ReviewsSection extends StatefulWidget {
  final String partnerId;
  final double height;

  const ReviewsSection({super.key, required this.partnerId, this.height = 280});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewsBloc>().add(
      FetchReviewsEvents(partnerId: widget.partnerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: BlocBuilder<ReviewsBloc, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewsLoaded) {
            final reviews = state.reviews;

            if (reviews.isEmpty) {
              return const Center(child: Text('No reviews yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];

                // Format date
                String dateString = '';
                if (review['createdAt'] != null) {
                  final timestamp = review['createdAt'];
                  final dateTime = timestamp.toDate();
                  dateString = DateFormat(
                    'dd MMM yyyy, hh:mm a',
                  ).format(dateTime);
                }

                // --------------------------------------------
                // 🔍 ORDER ITEMS PROCESSING + LOGGING
                // --------------------------------------------
                print("ORDER RAW DATA: ${review['order']}");
                print("ORDER TYPE: ${review['order']?.runtimeType}");

                final rawOrder = review['order'];
                List<Map<String, dynamic>> orderItems = [];

                if (rawOrder is List) {
                  orderItems = rawOrder
                      .map<Map<String, dynamic>>(
                        (item) => Map<String, dynamic>.from(item),
                      )
                      .toList();
                } else if (rawOrder is Map) {
                  orderItems = [Map<String, dynamic>.from(rawOrder)];
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile section
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/${review['image']}',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            review['name'] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        review['message'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 8),
                      ...orderItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "${item['name']} x${item['quantity']}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              height: 0.8,
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 8),

                      // Date
                      Text(
                        dateString,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFFF4F5F7),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Failed to load reviews.'));
        },
      ),
    );
  }
}
