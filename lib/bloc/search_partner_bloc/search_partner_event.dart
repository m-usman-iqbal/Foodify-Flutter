abstract class SearchPartnerEvent {}

class SearchPartnerQueryChanged extends SearchPartnerEvent {
  final String query;
  SearchPartnerQueryChanged(this.query);
}
