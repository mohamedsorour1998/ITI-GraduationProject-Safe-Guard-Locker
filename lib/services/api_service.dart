// Handles all the API-related operations like login, registration, and fetching lockers.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/locker.dart';

class ApiService {
  final String _baseUrl = 'https://your-api-url.com';

  Future<List<Locker>> getAvailableLockers() async {
    final response = await http.get(Uri.parse('$_baseUrl/available-lockers'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((lockerJson) => Locker.fromJson(lockerJson)).toList();
    } else {
      throw Exception('Failed to load available lockers');
    }
  }
Future<void> reserveLocker(int lockerId) async {
  final response = await http.patch(
    Uri.parse('$_baseUrl//lockers/$lockerId'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to reserve locker');
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
    Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Store the authentication token or user data as needed
      return true;
    } else {
      // Handle login failure
      return false;
    }
  }
}
