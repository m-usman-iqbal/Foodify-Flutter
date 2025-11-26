import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/favorite_model.dart';

class FavoriteService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<FavoriteModel>> fetchFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    final snapshot = await favRef.get();

    List<FavoriteModel> favorites = [];

    for (var doc in snapshot.docs) {
      final id = doc.id;
      final restaurant = await _firestore.collection('partners').doc(id).get();

      if (restaurant.exists) {
        final data = restaurant.data()!;
        favorites.add(
          FavoriteModel(
            id: id,
            title: data['title'] ?? 'No title',
            price: data['price'] ?? '',
            type: data['type'] ?? '',
            image: data['image'] ?? '',
            address: data['address'] ?? '',
            status: data['status'] ?? '',
            shipping: data['shipping'] ?? '',
            rating: data['rating'] ?? 0,
            distance: data['distance'] ?? 0,
          ),
        );
      }
    }

    return favorites;
  }
}
