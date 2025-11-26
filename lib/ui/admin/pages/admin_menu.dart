import 'package:burger/bloc/add_menu_bloc/add_menu_bloc.dart';
import 'package:burger/bloc/add_menu_bloc/add_menu_event.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_bloc.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_event.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_state.dart';
import 'package:burger/ui/admin/add_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  int active = 0;
  List<Map<String, dynamic>> menu = [];
  bool isLoading = true;
  late String partnerId;

  Future<String?> getRestaurantId() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data();
        final restaurantId = data?['restaurantId'] as String;
        print('✅ Restaurant ID: $restaurantId');
        partnerId = restaurantId;
        return restaurantId;
      } else {
        print('❌ User document not found.');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching restaurant ID: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenu() async {
    try {
      // Get current user id
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the menu collection of this partner
      final CollectionReference menuRef = FirebaseFirestore.instance
          .collection('partners')
          .doc(userId)
          .collection('menu');

      // Fetch documents
      final QuerySnapshot snapshot = await menuRef.get();

      // Map documents to a list of maps
      final List<Map<String, dynamic>> menuItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // include document ID

        return data;
      }).toList();

      setState(() {
        menu = menuItems;
        isLoading = false;
      });

      return menuItems;
    } catch (e) {
      print('Error fetching menu: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminMenuBloc>().add(CheckMenuEvent());
    });
    fetchMenu();
    getRestaurantId();
    context.read<AdminMenuBloc>().add(CheckMenuEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          onPressed: () async {
            // add async here
            final shouldReload = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMenuForm()),
            );

            if (shouldReload == true) {
              context.read<AdminMenuBloc>().add(CheckMenuEvent());
            }
          },
          backgroundColor: Color(0xFFEF9F27),
          foregroundColor: Colors.white,
          child: Text(
            "Add menu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ), // icon button ka andar
        ),
      ),
      body: BlocBuilder<AdminMenuBloc, AdminMenuState>(
        builder: (context, state) {
          if (state is AdminMenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminMenuHasMenu) {
            return Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Manage Restaurant",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => active = 0),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: active == 0
                              ? const Color(0xffEF9F27)
                              : const Color(0xff172B4D),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => active = 1),
                      child: Text(
                        'Popular items',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: active == 1
                              ? const Color(0xffEF9F27)
                              : const Color(0xff172B4D),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 145,
                      height: 2,
                      color: active == 0
                          ? const Color(0xffEF9F27)
                          : Colors.transparent,
                    ),
                    Container(
                      width: 145,
                      height: 2,
                      color: active == 1
                          ? const Color(0xffEF9F27)
                          : Colors.transparent,
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFF4F5F7)),

                if (active == 0)
                  AllMenuItems(items: state.menuItems, partnerId: partnerId),

                // Menu List / Popular List
                if (active == 1)
                  PopularMenuItems(
                    items: state.menuItems,
                    partnerId: partnerId,
                  ),
              ],
            );
          } else if (state is AdminMenuEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Restaurant already added ✅',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text('No menu yet — please add one 🍽️'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddMenuForm(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFEF9F27),
                      ),
                      child: const Center(
                        child: Text(
                          'Add Menu',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AdminMenuError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

// class AllMenuItems extends StatelessWidget {
//   final List<Map<String, dynamic>> items;
//   final String partnerId; // Needed to delete from Firestore

//   const AllMenuItems({super.key, required this.items, required this.partnerId});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: items.isEmpty
//             ? const Center(child: Text('No menu items found'))
//             : ListView.separated(
//                 itemCount: items.length,
//                 separatorBuilder: (_, __) =>
//                     const Divider(color: Color(0xFFF4F5F7), height: 1),
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//                   final String? menuId = item['id']; // could be null

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.asset(
//                             item['imagePath'],
//                             height: 80,
//                             width: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         // Details
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item['title'] ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 item['description'] ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xff7A869A),
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 'Price: ${item['price'] ?? ''}',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xff7A869A),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   try {
//                                     // Toggle the 'popular' field
//                                     await FirebaseFirestore.instance
//                                         .collection(
//                                           'partners',
//                                         ) // your partner collection
//                                         .doc(partnerId) // the partner document
//                                         .collection(
//                                           'menu',
//                                         ) // menu subcollection
//                                         .doc(menuId) // the menu item document
//                                         .update({
//                                           'popular':
//                                               !(item['popular'] ??
//                                                   false), // toggle true/false
//                                         });
//                                     print('✅ Popular status toggled!');
//                                     print(menuId);
//                                     print(partnerId);
//                                     context.read<AdminMenuBloc>().add(
//                                       CheckMenuEvent(),
//                                     );
//                                   } catch (e) {
//                                     print('❌ Error toggling popular: $e');
//                                   }
//                                 },
//                                 child: Icon(
//                                   item['popular'] == true
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: const Color(0xFFEF9F27),
//                                   size: 18,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Delete button (only if menuId exists)
//                         if (menuId != null)
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               print(
//                                 'Delete pressed: partnerId=$partnerId, menuId=$menuId',
//                               );

//                               context.read<MenuBloc>().add(
//                                 DeleteMenuItemEvent(
//                                   partnerId: partnerId,
//                                   menuId: menuId,
//                                 ),
//                               );
//                               context.read<AdminMenuBloc>().add(
//                                 CheckMenuEvent(),
//                               );
//                             },
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }

class AllMenuItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String partnerId; // Needed to delete from Firestore

  const AllMenuItems({super.key, required this.items, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: items.isEmpty
            ? const Center(child: Text('No menu items found'))
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFFF4F5F7), height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final String? menuId = item['id']; // could be null

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
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
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['description'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff7A869A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Price: ${item['price'] ?? ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff7A869A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete button and heart icon
                        if (menuId != null)
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  print(
                                    'Delete pressed: partnerId=$partnerId, menuId=$menuId',
                                  );

                                  context.read<MenuBloc>().add(
                                    DeleteMenuItemEvent(
                                      partnerId: partnerId,
                                      menuId: menuId,
                                    ),
                                  );
                                  context.read<AdminMenuBloc>().add(
                                    CheckMenuEvent(),
                                  );
                                },
                              ),
                              const SizedBox(height: 4), // small spacing
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('partners')
                                        .doc(partnerId)
                                        .collection('menu')
                                        .doc(menuId)
                                        .update({
                                          'popular':
                                              !(item['popular'] ?? false),
                                        });
                                    print('✅ Popular status toggled!');
                                    context.read<AdminMenuBloc>().add(
                                      CheckMenuEvent(),
                                    );
                                  } catch (e) {
                                    print('❌ Error toggling popular: $e');
                                  }
                                },
                                child: Icon(
                                  item['popular'] == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: const Color(0xFFEF9F27),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class PopularMenuItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String partnerId;

  const PopularMenuItems({
    super.key,
    required this.items,
    required this.partnerId,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only popular items
    final popularItems = items
        .where((item) => item['popular'] == true)
        .toList();

    if (popularItems.isEmpty) {
      return const Center(child: Text('No popular menu items'));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: popularItems.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Color(0xFFF4F5F7), height: 1),
          itemBuilder: (context, index) {
            final item = popularItems[index];
            final String? menuId = item['id'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
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
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff7A869A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Price: ${item['price'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff7A869A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Heart icon (toggle popular)
                  GestureDetector(
                    onTap: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('partners')
                            .doc(partnerId)
                            .collection('menu')
                            .doc(menuId)
                            .update({'popular': !(item['popular'] ?? false)});

                        // Refresh menu list
                        context.read<AdminMenuBloc>().add(CheckMenuEvent());
                      } catch (e) {
                        print('❌ Error toggling popular: $e');
                      }
                    },
                    child: Icon(
                      item['popular'] == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: const Color(0xFFEF9F27),
                      size: 18,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
