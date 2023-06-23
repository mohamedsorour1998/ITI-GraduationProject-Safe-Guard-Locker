// Defines the structure and properties of a locker object.
class Locker {
  final String id;
  final String name;
  final String size;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final int userId;

  Locker({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.userId,
    
  });

  // Create a factory method to construct a Locker object from JSON data
  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'],
      userId: json['userId'],
    );
  }

  // Create a method to convert a Locker object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'userId': userId,
    };
  }
}
