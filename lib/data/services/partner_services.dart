import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burger/domain/models/partners_model.dart';

class PartnersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Partner>> fetchPartners() async {
    final snapshot = await _firestore.collection('partners').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Partner(
        image: data['image'] ?? '',
        title: data['title'] ?? '',
        status: data['status'] ?? '',
        type: data['type'] ?? '',
        rating: (data['rating'] ?? 0).toDouble(),
        distance: data['distance']?.toString() ?? '',
        shipping: data['shipping']?.toString() ?? '',
        id: doc.id,
        address: data['address'],
      );
    }).toList();
  }
}
