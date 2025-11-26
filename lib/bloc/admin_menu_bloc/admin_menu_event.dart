import 'package:equatable/equatable.dart';

abstract class AdminMenuEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckMenuEvent extends AdminMenuEvent {}
