part of 'reviews_bloc.dart';

sealed class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object> get props => [];
}

class FetchReviewsEvents extends ReviewsEvent {
  final String partnerId;

  const FetchReviewsEvents({required this.partnerId});
}
