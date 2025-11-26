import 'package:burger/data/services/profile_services.dart';
import 'package:burger/domain/models/profile_model.dart';

class ProfileRepository {
  final ProfileServices service;
  ProfileRepository({required this.service});

  Future<ProfileFields> fetchProfileR() async {
    return await service.fetchProfile();
  }
}
