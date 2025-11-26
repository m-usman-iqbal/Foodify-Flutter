import 'package:burger/data/services/add_menu_services.dart';

class MenuRepository {
  final MenuService service;

  MenuRepository({required this.service});

  /// ✅ Add new menu item
  Future<void> addMenuItem({
    required String title,
    required String description,
    required double price,
    required bool popular,
    required String imagePath,
  }) async {
    await service.addMenuItem(
      title: title,
      description: description,
      price: price,
      popular: popular,
      imagePath: imagePath,
    );
  }

  /// ✅ Delete menu item
  Future<void> deleteMenuItem({
    required String partnerId,
    required String menuId,
  }) async {
    await service.deleteMenuItem(partnerId, menuId);
  }
}
