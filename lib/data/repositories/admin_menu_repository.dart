import '../services/admin_menu_services.dart';

class AdminMenuRepository {
  final AdminMenuServices service;

  AdminMenuRepository({required this.service});

  Future<List<Map<String, dynamic>>> getMenu() async {
    return await service.fetchMenu();
  }

  Future<bool> hasMenu() async {
    return await service.checkMenu();
  }
}
