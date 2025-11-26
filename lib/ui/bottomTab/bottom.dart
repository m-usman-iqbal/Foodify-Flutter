import 'package:burger/bloc/add_menu_bloc/add_menu_bloc.dart';
import 'package:burger/bloc/admin_menu_bloc/admin_menu_bloc.dart';
import 'package:burger/data/repositories/add_menu_repository.dart';
import 'package:burger/data/repositories/admin_menu_repository.dart';
import 'package:burger/data/services/add_menu_services.dart';
import 'package:burger/data/services/admin_menu_services.dart';
import 'package:burger/ui/admin/pages/add_partner.dart';
import 'package:burger/ui/admin/pages/admin_menu.dart';
import 'package:burger/ui/cart/pages/cart_screen.dart';
import 'package:burger/ui/home/home.dart';
import 'package:burger/ui/profile/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _hasRestaurant = false;
  bool _hasMenu = false;
  late String restaurantId;

  // final uid = FirebaseAuth.instance.currentUser!.uid;
  // final userDoc = FirebaseFirestore.instance.collection('users').doc(uid).get();
  // final restaurantId = userDoc.data()?['restaurantId'];

  final Color activeColor = const Color(0xFFEF9F27);
  final Color inactiveColor = const Color(0xffC1C7D0);

  @override
  void initState() {
    super.initState();
    _checkRestaurant();
  }

  Future<void> _checkRestaurant() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data()?['restaurantId'] != null) {
        restaurantId = userDoc.data()!['restaurantId'];
        setState(() {
          _hasRestaurant = true;
        });
      }
    } catch (e) {
      print('Error checking restaurant: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String uid1 = FirebaseAuth.instance.currentUser!.uid;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Widget> _screens = [
      const Home(),
      CartScreen(userId: uid1),
      const Profile(),
      _hasRestaurant
          ? MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AdminMenuBloc(
                    repository: AdminMenuRepository(
                      service: AdminMenuServices(restaurantId: restaurantId),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => MenuBloc(
                    repository: MenuRepository(service: MenuService()),
                  ),
                ),
              ],
              child: const AdminMenu(),
            )
          : Partner(), // replace with your Partner widget
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 88,
        color: Colors.white,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 26),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, size: 26),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
