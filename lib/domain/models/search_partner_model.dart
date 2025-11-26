class SearchPartnerModel {
  final String id;
  final String title;
  final String price;
  final String type;
  final String image;

  SearchPartnerModel({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    required this.image,
  });

  factory SearchPartnerModel.fromMap(String id, Map<String, dynamic> map) {
    return SearchPartnerModel(
      id: id,
      title: map['title'] ?? '',
      price: map['price'] ?? '',
      type: map['type'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
