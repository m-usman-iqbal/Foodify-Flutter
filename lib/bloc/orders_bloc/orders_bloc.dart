import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:burger/data/repositories/order_repository.dart';
import 'package:burger/data/services/order_services.dart';
import 'package:equatable/equatable.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final repository = OrderRepository(service: OrderServices());
  StreamSubscription? _partnerOrdersSubscription;
  OrdersBloc() : super(OrdersInitial()) {
    on<FetchUserOrdersEvent>((event, emit) async {
      emit(OrdersLoading());

      try {
        final orders = await repository.get();
        emit(OrdersLoaded(orders: orders));
      } catch (e) {
        emit(OrdersFailed(message: 'failed fetching of the orders.'));
      }
    });

    on<StartListeningPartnerOrdersEvent>((event, emit) async {
      _partnerOrdersSubscription?.cancel();

      _partnerOrdersSubscription = repository
          .getPartnerOrders(event.partnerId)
          .listen((orders) {
            add(PartnerOrdersUpdatedEvent(orders)); // Fire event for new data
          });
    });
    on<PartnerOrdersUpdatedEvent>((event, emit) {
      emit(OrdersLoaded(orders: event.orders));
    });
  }
  @override
  Future<void> close() {
    _partnerOrdersSubscription?.cancel();
    return super.close();
  }
}
