import 'package:burger/domain/models/add_partner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PartnerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addPartner(AddPartner partner) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('partners')
          .add(partner.toMap());

      final String uid = _auth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).update({
        'restaurantId': docRef.id,
      });
    } catch (e) {
      print('Error adding partner: $e');
      rethrow;
    }
  }
}
