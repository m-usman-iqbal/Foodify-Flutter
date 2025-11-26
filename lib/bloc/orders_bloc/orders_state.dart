part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<Map<String, dynamic>> orders;

  const OrdersLoaded({required this.orders});
}

final class OrdersFailed extends OrdersState {
  final String message;
  const OrdersFailed({required this.message});
  @override
  List<Object> get props => [message];
}
