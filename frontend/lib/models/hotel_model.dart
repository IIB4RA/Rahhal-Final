class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final String price;
  final String imageUrl;
  final String distance;
  final bool isTopRated;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
    required this.distance,
    this.isTopRated = false,
  });
}