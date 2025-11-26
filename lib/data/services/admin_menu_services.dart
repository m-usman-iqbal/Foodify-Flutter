import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminMenuServices {
  final restaurantId;
  AdminMenuServices({required this.restaurantId});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch menu items instead of just checking
  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (restaurantId == null) return [];

    // Get menu collection
    final menuSnapshot = await _firestore
        .collection('partners')
        .doc(restaurantId)
        .collection('menu')
        .get();

    // Map to List<Map<String, dynamic>>
    return menuSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // include document ID
      return data;
    }).toList();
  }

  // Optional: keep old checkMenu method if needed
  Future<bool> checkMenu() async {
    final menu = await fetchMenu();
    return menu.isNotEmpty;
  }
}
