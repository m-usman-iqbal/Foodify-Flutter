import 'package:burger/domain/models/partners_model.dart';
import 'package:burger/ui/restaurnts/pages/restaurant_profile.dart';
import 'package:burger/ui/favorite/pages/favorite.dart';
import 'package:burger/utils/add_favorite_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Search box
          Container(
            margin: EdgeInsets.fromLTRB(35, 52, 35, 24),
            decoration: BoxDecoration(
              color: Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(15),
            ),
            height: 44,
            width: double.infinity,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
                border: InputBorder.none,
                hintText: "Search on Coody",
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7A869A)),
                suffixIcon: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(9),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff42526E),
                    ),
                    child: Center(
                      child: Icon(Icons.close, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          // 🔹 Only show results if search query is not empty
          Expanded(
            child: searchQuery.isEmpty
                ? Center(
                    child: Text(
                      "Search to find your favorite restaurant",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('partners')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          // Filter documents by search query (case-insensitive)
                          final filtered = snapshot.data!.docs.where((doc) {
                            final title = (doc['title'] as String)
                                .toLowerCase();
                            return title.startsWith(searchQuery);
                          }).toList();

                          if (filtered.isEmpty) {
                            return Center(
                              child: Text(
                                "No restaurants found",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final doc = filtered[index];
                              final restaurantId = doc.id;
                              final title = doc['title'];
                              final price = doc['price'];
                              final type = doc['type'];
                              final rating = doc['rating'];
                              final image = doc['image'];

                              final partner = Partner(
                                image: doc['image'],
                                title: doc['title'],
                                status: doc['status'],
                                type: doc['type'],
                                rating: doc['rating'],
                                distance: doc['distance'].toString(),
                                shipping: doc['shipping'],
                                id: doc.id,
                                address: doc['address'],
                              );

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RestaurantProfile(
                                        partner: [partner],
                                        restaurantId: doc.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 8, 16, 8),
                                  height: 128,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              height: 80,
                                              width: 80,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      15,
                                                    ), // 👈 add this line
                                                child: Image.asset(
                                                  'assets/$image',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              30,
                                              0,
                                              30,
                                            ),
                                            child: SizedBox(
                                              width: 190,
                                              height: 52,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 190,
                                                    height: 24,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        FavoriteButton(
                                                          key: ValueKey(
                                                            restaurantId,
                                                          ),
                                                          restaurantId:
                                                              restaurantId,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    height: 28,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "$price USD",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                              0xffEF9F27,
                                                            ),
                                                          ),
                                                        ),
                                                        Text('•'),
                                                        Text(
                                                          type,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        width: double.infinity, // full width
                                        height: 1, // 1 pixel tall
                                        color: Color(
                                          0xFFECECEC,
                                        ), // slightly darker
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
