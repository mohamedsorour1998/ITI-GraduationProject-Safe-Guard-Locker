class Locker {
  final int id;
  final String size;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final String? userId;
  final String lockerPhysicalStatus;

  Locker({
    required this.id,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    this.userId,
    required this.lockerPhysicalStatus,
  });

  factory Locker.fromJson(Map<String, dynamic> json) {
    try {
      String? userId;
      if (json.containsKey('reservee_id') && json['reservee_id'] != '') {
        userId = json['reservee_id'].toString();
      } else
        if (json.containsKey('app_user_id') && json['app_user_id'] != '') {
        userId = json['app_user_id'].toString();
      } else {
        userId = null;
      }

      return Locker(
        id: int.parse(json['locker_id'].toString()),
        size: json['locker_size'],
        price: double.parse(json['Locker_price'].toString()),
        imageUrl: json['locker_image_url'],
        isAvailable: json['availability_status'].toString().toLowerCase() == 'true',
        userId: userId,
        lockerPhysicalStatus: json['locker_physical_status'],
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
      'locker_id': id,
      'locker_size': size,
      'Locker_price': price,
      'locker_image_url': imageUrl,
      'availability_status': isAvailable,
      'reservee_id': userId,
      'locker_physical_status': lockerPhysicalStatus,
    };
  }
  set userId(String? newUserId) => this.userId = newUserId;
  set isAvailable(bool newIsAvailable) => this.isAvailable = newIsAvailable;
}