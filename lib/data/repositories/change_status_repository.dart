import 'package:burger/data/services/change_status_services.dart';

class ChangeStatusRepository {
  final ChangeStatusServices services;
  ChangeStatusRepository({required this.services});

  Future<void> updateStatus(String oId, String cId, String pId) async {
    return await services.changeStatus(oId, cId, pId);
  }
}
