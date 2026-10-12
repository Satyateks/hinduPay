class Pandit {
  final String id;
  final String name;
  final String specialization; // Jaise: 'Rudrabhishek', 'Griha Pravesh', 'Satyanarayan'
  final String imageUrl;
  final String location;
  final double rating;
  final List<String> supportedPoojas; // Pooja filter ke liye

  const Pandit({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.supportedPoojas,
  });
}