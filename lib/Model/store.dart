class Store {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  String? createdAt;
  final String image; // Added image field

  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    required this.image, // Added image field
  });

  // Method to convert Store object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'image': image, // Include image field in the map
    };
  }
}
