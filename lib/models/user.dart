// user.dart

class User {
  final String id;
  final String email;
  final String password;
  final String? fullName;
  final String? phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
  });

  // Create a factory method to construct a User object from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['app_user_id'] as String,
      email: json['email'],
      password: json['password'],
      fullName: json['name'],
      phoneNumber: json['phone_number'],
    );
  }

  // Create a method to convert a User object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}