class Event {
  final String title;
  final String date;
  final String location;
  final String description;
  final String imageUrl;
  final String buttonText;
  final String category;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.buttonText = "Book Tickets",
    this.category = "Cultural",
  });
}