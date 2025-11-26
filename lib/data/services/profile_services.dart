import 'package:burger/domain/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileServices {
  Future<ProfileFields> fetchProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return ProfileFields(
          address: data['address'] as String?,
          username: data['username'] as String?,
          email: data['email'] as String?,
          imagePath: data['imagePath'] as String?,
        );
      } else {
        throw Exception('Document does not exist for uid: $uid');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
