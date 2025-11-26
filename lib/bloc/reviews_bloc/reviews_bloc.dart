import 'package:bloc/bloc.dart';
import 'package:burger/data/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final OrderRepository repository;
  ReviewsBloc({required this.repository}) : super(ReviewsInitial()) {
    on<FetchReviewsEvents>(onFetchReviews);
  }
  Future<void> onFetchReviews(
    FetchReviewsEvents event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(ReviewsLoading());
    try {
      // Call repository to fetch reviews
      final reviews = await repository.getReviews(event.partnerId);
      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewsFailed());
    }
  }
}
