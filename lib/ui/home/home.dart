// ignore_for_file: unnecessary_cast
import 'package:burger/ui/restaurnts/pages/restaurant_profile.dart';
import 'package:burger/ui/favorite/pages/favorite.dart';
import 'package:burger/ui/partners/pages/all_partners.dart';
import 'package:burger/ui/searching/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burger/domain/models/partners_model.dart' show Partner;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var active = 0;
  // ignore: non_constant_identifier_names
  String Label = 'category';
  double _currentValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F7),

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            height: 190,
            width: double.infinity,
            child: Stack(
              children: [
                // 🔸 Main scrollable content
                Container(
                  margin: EdgeInsets.fromLTRB(35, 52, 35, 16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F5F7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 44,
                        width: double.infinity,
                        child: TextField(
                          readOnly: true, // prevents keyboard from opening
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search()),
                            );
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search on Coody",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A869A),
                            ),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Color(0xFF7A869A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 46,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/arrow.png',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery to',
                                    style: TextStyle(
                                      color: Color(0xFFEF9F27),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '1014 Prospect Vall',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Favorite(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 90,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xffEF9F27),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                        'Favorites',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    height: 329,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 68,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text(
                                  'Best Partners',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllPartners(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'See all partners',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xFFF4F5F7),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('partners')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Center(child: Text('No partners found'));
                              }

                              final partners = snapshot.data!.docs;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(partners.length, (
                                    index,
                                  ) {
                                    final data =
                                        partners[index].data()
                                            as Map<String, dynamic>;
                                    final title = data['title'] ?? 'No Title';
                                    final image = data['image'];
                                    final status = data['status'] ?? '';
                                    final address = data['address'] ?? '';
                                    final rating1 = data['rating'];
                                    final rating = data['rating'].toString();

                                    final distance =
                                        data['distance']?.toString() ?? '0';
                                    final shipping = data['shipping'] ?? '';
                                    final type = data['type'];
                                    final id = partners[index].id;

                                    final partner = Partner(
                                      image: image,
                                      title: title,
                                      status: status,
                                      type: type,
                                      rating: rating1,
                                      distance: distance,
                                      shipping: shipping,
                                      id: id,
                                      address: address,
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RestaurantProfile(
                                                    partner: [partner],
                                                    restaurantId: id,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 238,
                                          width: 205,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                height: 116,
                                                width: 205,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.asset(
                                                    'assets/$image',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              SizedBox(
                                                height: 26,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Image.asset(
                                                      'assets/verify.png',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              SizedBox(
                                                height: 20,
                                                width: 169,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      status,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color(
                                                          0xff00875A,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: 2,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(
                                                          0xffC1C7D0,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      address,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              SizedBox(
                                                height: 24,
                                                width: 191,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 24,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                          0xffEF9F27,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.white,
                                                              size: 10,
                                                            ),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              rating,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: 2,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(
                                                          0xffC1C7D0,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      '${distance}Km',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: 2,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(
                                                          0xffC1C7D0,
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      shipping,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  //   height: 698,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       // top tab bar
                  //       SizedBox(
                  //         height: 81,
                  //         width: double.infinity,
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(20),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,

                  //             children: [
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Popular Restaurants',
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),

                  //       // future builder for Firebase items
                  //       Expanded(
                  //         child: FutureBuilder(
                  //           future: FirebaseFirestore.instance
                  //               .collection('nearby')
                  //               .get(),
                  //           builder: (context, snapshot) {
                  //             if (snapshot.connectionState ==
                  //                 ConnectionState.waiting) {
                  //               return SizedBox.expand(
                  //                 child: Center(
                  //                   child: CircularProgressIndicator(),
                  //                 ),
                  //               );
                  //             }

                  //             if (snapshot.hasError) {
                  //               return Center(
                  //                 child: Text('Error: ${snapshot.error}'),
                  //               );
                  //             }

                  //             if (!snapshot.hasData ||
                  //                 snapshot.data!.docs.isEmpty) {
                  //               return Center(
                  //                 child: Text('No nearby items found'),
                  //               );
                  //             }

                  //             final items = snapshot.data!.docs;

                  //             return ListView.builder(
                  //               padding: EdgeInsets.symmetric(horizontal: 16),
                  //               itemCount: items.length,
                  //               itemBuilder: (context, index) {
                  //                 final data =
                  //                     items[index].data()
                  //                         as Map<String, dynamic>;
                  //                 final title = data['title'] ?? 'No Title';
                  //                 final image = data['image'];
                  //                 final rating = data['rating'] ?? 0.0;
                  //                 final distance = data['distance'] ?? 0.0;
                  //                 final freeShipping =
                  //                     data['free_shipping'] ?? '';
                  //                 final menu = List<String>.from(
                  //                   data['menu'] ?? [],
                  //                 );

                  //                 return Container(
                  //                   height: 294,
                  //                   width: 303,
                  //                   margin: EdgeInsets.only(bottom: 20),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Container(
                  //                         height: 172,
                  //                         width: 303,
                  //                         decoration: BoxDecoration(
                  //                           borderRadius: BorderRadius.circular(
                  //                             15,
                  //                           ),
                  //                         ),
                  //                         child: ClipRRect(
                  //                           borderRadius: BorderRadius.circular(
                  //                             15,
                  //                           ),
                  //                           child: Image.asset(
                  //                             'assets/$image',
                  //                             height: 172,
                  //                             fit: BoxFit.cover,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 16),
                  //                       SizedBox(
                  //                         height: 26,
                  //                         width: 150,
                  //                         child: Row(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             Text(
                  //                               title,
                  //                               style: TextStyle(
                  //                                 fontSize: 20,
                  //                                 fontWeight: FontWeight.bold,
                  //                               ),
                  //                             ),
                  //                             SizedBox(width: 2),
                  //                             Image.asset('assets/verify.png'),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 4),
                  //                       SizedBox(
                  //                         height: 20,
                  //                         width: 250,
                  //                         child: Row(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             ...List.generate(menu.length, (
                  //                               i,
                  //                             ) {
                  //                               return Row(
                  //                                 children: [
                  //                                   Text(
                  //                                     menu[i],
                  //                                     style: TextStyle(
                  //                                       fontSize: 12,
                  //                                       fontWeight:
                  //                                           FontWeight.w500,
                  //                                       color: i == 0
                  //                                           ? Color(0xff00875A)
                  //                                           : Colors.black,
                  //                                     ),
                  //                                   ),
                  //                                   if (i <
                  //                                       menu.length - 1) ...[
                  //                                     SizedBox(width: 10),
                  //                                     Container(
                  //                                       height: 2,
                  //                                       width: 2,
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                             shape: BoxShape
                  //                                                 .circle,
                  //                                             color: Color(
                  //                                               0xffC1C7D0,
                  //                                             ),
                  //                                           ),
                  //                                     ),
                  //                                     SizedBox(width: 10),
                  //                                   ],
                  //                                 ],
                  //                               );
                  //                             }),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 12),
                  //                       SizedBox(
                  //                         height: 24,
                  //                         width: 256,
                  //                         child: Row(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             Container(
                  //                               height: 24,
                  //                               width: 50,
                  //                               decoration: BoxDecoration(
                  //                                 color: Color(0xffEF9F27),
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(15),
                  //                               ),
                  //                               child: Center(
                  //                                 child: Row(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Icon(
                  //                                       Icons.star,
                  //                                       color: Colors.white,
                  //                                       size: 10,
                  //                                     ),
                  //                                     SizedBox(width: 4),
                  //                                     Text(
                  //                                       rating.toString(),
                  //                                       style: TextStyle(
                  //                                         fontSize: 12,
                  //                                         color: Colors.white,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Spacer(),
                  //                             Container(
                  //                               height: 2,
                  //                               width: 2,
                  //                               decoration: BoxDecoration(
                  //                                 shape: BoxShape.circle,
                  //                                 color: Color(0xffC1C7D0),
                  //                               ),
                  //                             ),
                  //                             Spacer(),
                  //                             Row(
                  //                               children: [
                  //                                 Icon(
                  //                                   Icons.location_on,
                  //                                   size: 11,
                  //                                   color: Color(0xffC1C7D0),
                  //                                 ),
                  //                                 SizedBox(width: 10),
                  //                                 Text(
                  //                                   '${distance}Km',
                  //                                   style: TextStyle(
                  //                                     fontSize: 12,
                  //                                     fontWeight:
                  //                                         FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             Spacer(),
                  //                             Container(
                  //                               height: 2,
                  //                               width: 2,
                  //                               decoration: BoxDecoration(
                  //                                 shape: BoxShape.circle,
                  //                                 color: Color(0xffC1C7D0),
                  //                               ),
                  //                             ),
                  //                             Spacer(),
                  //                             Row(
                  //                               children: [
                  //                                 Image.asset(
                  //                                   'assets/Time.png',
                  //                                   height: 24,
                  //                                   width: 24,
                  //                                 ),
                  //                                 SizedBox(width: 10),
                  //                                 Text(
                  //                                   freeShipping,
                  //                                   style: TextStyle(
                  //                                     fontSize: 12,
                  //                                     fontWeight:
                  //                                         FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 );
                  //               },
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // helper for top tabs
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilter(String label) {
    if (label == 'sort') {
      {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF4F5F7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/bookmark.png',
                        height: 15,
                        width: 15,
                      ),
                    ),
                    Text('Recommended'),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF4F5F7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/times.png',
                        height: 15,
                        width: 15,
                      ),
                    ),
                    Text('Fastest delivery'),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF4F5F7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/flame.png',
                        height: 15,
                        width: 15,
                      ),
                    ),
                    Text('Most Popular'),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffEF9F27),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else if (label == 'price') {
      return SizedBox(
        height: 186,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Max delivery fee',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 106,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$ 5.00', style: TextStyle(fontSize: 16)),
                        Text('\$ 10.00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Slider(
                    value: _currentValue,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    activeColor: Color(0xffEF9F27),
                    label: _currentValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffEF9F27),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text('Complete', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 192,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 138,
                  width: 100,
                  child: Column(
                    children: [
                      Image.asset('assets/sand.png'),
                      SizedBox(height: 8),
                      Text(
                        'Sandwiches',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 138,
                  width: 100,
                  child: Column(
                    children: [
                      Image.asset('assets/pizza.png'),
                      SizedBox(height: 8),
                      Text(
                        'Pizzas',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 138,
                  width: 100,
                  child: Column(
                    children: [
                      Image.asset('assets/bb.png'),
                      SizedBox(height: 8),
                      Text(
                        'Burgers',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffEF9F27),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text('Complete', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }
}

Widget buildTab(String label, int index, int active) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          color: active == index ? Color(0xffEF9F27) : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 18),
      Container(
        width: 64.62,
        height: 2,
        color: active == index ? Color(0xffEF9F27) : Colors.white,
      ),
    ],
  );
}
