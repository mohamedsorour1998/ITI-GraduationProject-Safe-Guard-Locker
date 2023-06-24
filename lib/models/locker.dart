class Locker {
  final int id;
  final String name;
  final String size;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final int? userId;

  Locker({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    this.userId,
  });

  factory Locker.fromJson(Map<String, dynamic> json) {
    try {
      return Locker(
        id: int.parse(json['id'].toString()), // Convert the id to an integer
        name: json['name'],
        size: json['size'],
        price: json['price'].toDouble(),
        imageUrl: json['imageUrl'],
        isAvailable: json['isAvailable'],
        userId: json['userId'],
      );
    } catch (e) {
      if (e is TypeError) {
        print('Error: $e');
        print('JSON causing the error: $json');
      }
      rethrow;
    }
  }

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
