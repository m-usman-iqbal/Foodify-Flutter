class AddPartner {
  final String title;
  final String address;
  final double distance;
  final double rating;
  final String shipping;
  final String status;
  final String price;
  final String type;
  final String image;
  final String owner;

  AddPartner({
    required this.title,
    required this.address,
    required this.distance,
    required this.rating,
    required this.shipping,
    required this.status,
    required this.price,
    required this.type,
    required this.image,
    required this.owner,
  });

  // Convert Partner to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'address': address,
      'distance': distance,
      'rating': rating,
      'shipping': shipping,
      'status': status,
      'price': price,
      'type': type,
      'image': image,
      'createdAt': DateTime.now(),
      'owner': owner,
    };
  }

  // Create Partner from Firestore Map
  factory AddPartner.fromMap(Map<String, dynamic> map) {
    return AddPartner(
      title: map['title'] ?? '',
      address: map['address'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      shipping: map['shipping'] ?? '',
      status: map['status'] ?? '',
      price: map['price'] ?? '',
      type: map['type'] ?? '',
      image: map['image'] ?? '',
      owner: map['owner'] ?? '',
    );
  }
}
