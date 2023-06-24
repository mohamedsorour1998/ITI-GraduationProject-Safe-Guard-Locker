// Handles all the API-related operations like login, registration, and fetching lockers.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/locker.dart';
import '../models/user.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Locker>> getAvailableLockers() async {
    final response = await http.get(Uri.parse('$_baseUrl/available-lockers'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      print('Raw server response: $data'); // Add this line

      return data.map((lockerJson) => Locker.fromJson(lockerJson)).toList();
    } else {
      throw Exception('Failed to load available lockers');
    }
  }

  Future<String> getUserEmail(int? userId) async {
    if (userId == null) {
      return '';
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get user email');
    }

    return jsonDecode(response.body)['email'];
  }

  Future<void> reserveLocker(int lockerId, int userId) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/lockers/$lockerId'),
      body: json.encode({
        'userId': userId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reserve locker');
    }

    print(jsonDecode(response.body)['message']);
  }

  Future<void> unreserveLocker(int lockerId) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/lockers/$lockerId/unreserve'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unreserve locker');
    }

    print(jsonDecode(response.body)['message']);
  }

  Future<bool> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Handle registration failure
      return false;
    }
  }

  Future<int?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Store the user ID as needed
      return int.parse(jsonDecode(response.body)['userId']);
    } else {
      // Handle login failure
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/users/email/$email'));
      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Add this print statement
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load the user. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in getUserByEmail: $e');
      return null;
    }
  }
}
