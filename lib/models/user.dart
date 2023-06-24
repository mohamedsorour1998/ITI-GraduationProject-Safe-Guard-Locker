// defines the structure and properties of a user object.
class User {
  final int id;
  final String email;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.password,
  });

  // Create a factory method to construct a User object from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'],
      password: json['password'],
    );
  }

  // Create a method to convert a User object to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}
