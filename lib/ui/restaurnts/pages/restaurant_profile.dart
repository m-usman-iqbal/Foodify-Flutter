import 'package:burger/bloc/admin_menu_bloc/admin_menu_bloc.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_event.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_state.dart';
import 'package:burger/bloc/partner_bloc/partners_bloc.dart';
import 'package:burger/data/repositories/admin_menu_repository.dart';
import 'package:burger/data/services/admin_menu_services.dart';
import 'package:burger/ui/restaurnts/pages/details.dart';
import 'package:burger/domain/models/partners_model.dart';
import 'package:burger/ui/cart/pages/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantProfile extends StatefulWidget {
  final List<Partner> partner;
  final String restaurantId;
  const RestaurantProfile({
    super.key,
    required this.partner,
    required this.restaurantId,
  });

  @override
  State<RestaurantProfile> createState() => _RestaurantProfileState();
}

class _RestaurantProfileState extends State<RestaurantProfile> {
  @override
  void initState() {
    super.initState();
    // Fire the event after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminMenuBloc>().add(CheckMenuEvent());
    });
  }

  int active = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AdminMenuBloc(
          repository: AdminMenuRepository(
            service: AdminMenuServices(restaurantId: widget.restaurantId),
          ),
        )..add(CheckMenuEvent()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none, // important to allow overflow
            children: [
              ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Image.asset(
                  'assets/${widget.partner[0].image}',
                  height: 212,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 25,
                left: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios, // iOS style arrow
                    size: 20, // chhota size
                    color: Colors.black, // color change kar sakte ho
                  ),
                  onPressed: () {
                    Navigator.pop(context); // back action
                  },
                ),
              ),

              // Pink container overlapping the image
              Positioned(
                top: 190, // start overlapping 62px from bottom of image
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title contianer
                      Container(
                        height: 67,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //title and verification
                                SizedBox(
                                  height: 26,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.partner[0].title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Image.asset('assets/verify.png'),
                                    ],
                                  ),
                                ),
                                // Spacer(),
                                SizedBox(
                                  height: 26,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.partner[0].type,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffEF9F27),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.favorite,
                                        color: Color(0xffEF9F27),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            SizedBox(
                              height: 20,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.partner[0].status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                    width: 3, // dot size
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Color(0xffC1C7D0), // dot color
                                      shape: BoxShape
                                          .circle, // makes it perfectly round
                                    ),
                                  ),
                                  Text(
                                    widget.partner[0].address,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff7A869A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //line
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity, // full width
                              height: 1, // 1 pixel tall
                              color: Color(0xFFF4F5F7), // your color
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        height: 25,
                        width: double.infinity,
                        //main column
                        child: Column(
                          children: [
                            //first row
                            SizedBox(
                              height: 24,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEF9F27),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.partner[0].rating.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 2,
                                    width: 2,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffC1C7D0),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 11,
                                        color: Color(0xffC1C7D0),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${widget.partner[0].distance.toString()} km",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 2,
                                    width: 2,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffC1C7D0),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/Time.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.partner[0].shipping,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 24),
                            // Container(
                            //   padding: EdgeInsets.all(12),
                            //   height: 44,
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     color: Color(0xffF4F5F7),
                            //     borderRadius: BorderRadius.circular(15),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Image.asset('assets/percentage.png'),
                            //       Text('Save \$15.00 with code Total Dish'),
                            //       Text(
                            //         'd',
                            //         style: TextStyle(color: Color(0xffF4F5F7)),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity, // full width
                        height: 1, // 1 pixel tall
                        color: Color(0xFFF4F5F7), // your color
                      ),

                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            // ---------- TAB BAR ----------
                            Container(
                              height: 45,
                              child: TabBar(
                                dividerColor: Colors
                                    .transparent, // removes default grey line

                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),

                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(
                                      0xffEF9F27,
                                    ), // your selected underline color
                                  ),
                                  insets: EdgeInsets.symmetric(horizontal: 40),
                                ),

                                labelColor: Color(0xffEF9F27), // active color
                                unselectedLabelColor: Color(
                                  0xff172B4D,
                                ), // inactive color

                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),

                                tabs: [
                                  Tab(text: "Menu"),
                                  Tab(text: "Popular"),
                                  Tab(text: "Reviews"),
                                ],
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(0xFFF4F5F7), // your color
                            ),

                            SizedBox(
                              height: 349,
                              child: TabBarView(
                                children: [
                                  BlocBuilder<AdminMenuBloc, AdminMenuState>(
                                    builder: (context, state) {
                                      if (state is AdminMenuLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is AdminMenuHasMenu) {
                                        final menuItems = state.menuItems;
                                        return PopularItems(items: menuItems);
                                      } else {
                                        return const Text("no menu yet");
                                      }
                                    },
                                  ),

                                  BlocBuilder<AdminMenuBloc, AdminMenuState>(
                                    builder: (context, state) {
                                      if (state is AdminMenuLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is AdminMenuHasMenu) {
                                        final menuItems = state.menuItems;
                                        final popularItems = menuItems
                                            .where(
                                              (item) => item['popular'] == true,
                                            )
                                            .toList();
                                        return PopularItems2(
                                          items: popularItems,
                                        );
                                      } else {
                                        return const Text("no menu yet");
                                      }
                                    },
                                  ),

                                  ReviewsSection(
                                    partnerId: widget.partner[0].id,
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
            ],
          ),
        ),
      ),
    );
  }
}

class PopularItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const PopularItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(item: item),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/${item['imagePath']}',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rs ${item['price'].toString()}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff7A869A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     // Handle toggle logic outside or pass a callback
                            //   },
                            //   icon: Icon(
                            //     item['isFav']
                            //         ? Icons.favorite
                            //         : Icons.favorite_border,
                            //     color: const Color(0xffEF9F27),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFFF4F5F7),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PopularItems2 extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const PopularItems2({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(item: item),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/${item['imagePath']}',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rs ${item['price'].toString()}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff7A869A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     // Handle toggle logic outside or pass a callback
                            //   },
                            //   icon: Icon(
                            //     item['isFav']
                            //         ? Icons.favorite
                            //         : Icons.favorite_border,
                            //     color: const Color(0xffEF9F27),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFFF4F5F7),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
