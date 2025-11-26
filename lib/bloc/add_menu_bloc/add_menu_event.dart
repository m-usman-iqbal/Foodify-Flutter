import 'package:equatable/equatable.dart';

abstract class AdminMenuItemEvent extends Equatable {
  const AdminMenuItemEvent();

  @override
  List<Object?> get props => [];
}

class AddMenuItemEvent extends AdminMenuItemEvent {
  final String title;
  final String description;
  final double price;
  final bool popular;
  final String imagePath;

  const AddMenuItemEvent({
    required this.title,
    required this.description,
    required this.price,
    required this.popular,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, description, price, popular, imagePath];
}

class DeleteMenuItemEvent extends AdminMenuItemEvent {
  final String partnerId;
  final String menuId;

  const DeleteMenuItemEvent({required this.partnerId, required this.menuId});

  @override
  List<Object?> get props => [partnerId, menuId];
}
