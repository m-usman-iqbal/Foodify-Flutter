import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Delete a menu item
  Future<void> deleteMenuItem(String partnerId, String menuId) async {
    try {
      await _firestore
          .collection('partners')
          .doc(partnerId)
          .collection('menu')
          .doc(menuId)
          .delete();
      print('✅ Menu item deleted successfully');
    } catch (e) {
      print('❌ Error deleting menu item: $e');
      rethrow;
    }
  }

  /// ✅ Add a menu item
  Future<void> addMenuItem({
    required String title,
    required String description,
    required double price,
    required bool popular,
    required String? imagePath,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await _firestore.collection('users').doc(uid).get();
    final restaurantId = userDoc.data()?['restaurantId'];

    if (restaurantId == null) {
      throw Exception('User has no restaurant assigned!');
    }

    final menuDoc = _firestore
        .collection('partners')
        .doc(restaurantId)
        .collection('menu')
        .doc();

    final menuItem = {
      'id': menuDoc.id,
      'title': title,
      'description': description,
      'price': price,
      'popular': popular,
      'imagePath': imagePath ?? '',
      'partnerId': restaurantId,
    };

    await menuDoc.set(menuItem);
  }
}
