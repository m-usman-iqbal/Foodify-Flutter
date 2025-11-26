import 'package:burger/data/services/add_partner_servies.dart';
import 'package:burger/domain/models/add_partner_model.dart';

class PartnerRepository {
  final PartnerService service;

  PartnerRepository({required this.service});

  Future<void> addPartner(AddPartner partner) async {
    return service.addPartner(partner);
  }
}
