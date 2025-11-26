import 'package:burger/domain/models/search_partner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPartnerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SearchPartnerModel>> fetchPartners() async {
    final snapshot = await _firestore.collection('partners').get();
    return snapshot.docs
        .map((doc) => SearchPartnerModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
