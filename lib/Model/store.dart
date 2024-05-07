class Store {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  String? createdAt;
  final String image;
 bool isFavorite; 

  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    required this.image,
  this.isFavorite = false, // Added image field
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
