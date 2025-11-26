part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class FetchUserOrdersEvent extends OrdersEvent {}

class FetchPartnerOrdersEvent extends OrdersEvent {}

class StartListeningPartnerOrdersEvent extends OrdersEvent {
  final String partnerId;
  const StartListeningPartnerOrdersEvent({required this.partnerId});
}

class PartnerOrdersUpdatedEvent extends OrdersEvent {
  final List<Map<String, dynamic>> orders;
  const PartnerOrdersUpdatedEvent(this.orders);

  @override
  List<Object> get props => [orders];
}
