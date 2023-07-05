// Handles all the API-related operations like login, registration, and fetching lockers.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/locker.dart';
import '../models/user.dart';

class ApiService {

  Future<List<Locker>> getAvailableLockers() async {
    final String _baseUrl = 'https://beta.masterofthings.com';
    final body = jsonEncode({
      'AppId': 196,
      'ConditionList': [],
      'Auth': {
        'Key': '4krM5XHatWA3WFDz1688051149202Locker_Management_System_Locker_Data',
      },
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/GetAppReadingValueList'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['Result'] as List;

      print('Raw server response: $data'); // Add this line

      return data.map((lockerJson) => Locker.fromJson(lockerJson)).toList();
    } else {
      throw Exception('Failed to load available lockers');
    }
  }

  Future<String> getUserEmail(String? userId) async {
    if (userId == null) {
      return '';
    }
    print('Getting email for user ID: $userId');

    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'AppId': 195,
          'ConditionList': [
            {
              'Reading': 'app_user_id',
              'Condition': 'e',
              'Value': userId,
            },
          ],
          'Auth': {
            'Key':
            'XzeIpngQu7AjlKir1688050464151Locker_Management_System_Use_Data',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('API response: ${response.body}');
        final data = jsonDecode(response.body)['Result'];
        if (data.isNotEmpty) {
          return data[0]['email'];
        } else {
          throw Exception('Failed to get user email: Empty result');
        }
      } else {
        throw Exception(
            'Failed to get user email: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in getUserEmail: $e');
      throw Exception('Failed to get user email');
    }
  }

  // In api_service.dart


  Future<void> reserveLocker(int lockerId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/safeguard_lockers/reserve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Auth': {
            'DriverManagerId': '1',
            'DriverManagerPassword': '123',
          },
          'userId': userId,
          'lockerId': lockerId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Locker reserved successfully');
      } else if (response.statusCode == 409) {
        final error = jsonDecode(response.body)['error'];
        print('Failed to reserve locker: $error');
        throw Exception('Failed to reserve locker: $error');
      } else {
        throw Exception(
            'Failed to reserve locker: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in reserveLocker: $e');
      throw Exception('Failed to reserve locker');
    }
  }

  // In api_service.dart

  Future<void> unreserveLocker(int lockerId) async {
    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/safeguard_lockers/unreserve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Auth': {
            'DriverManagerId': '1',
            'DriverManagerPassword': '123',
          },
          'lockerId': lockerId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Locker reservation has been cancelled!');
      } else if (response.statusCode == 409) {
        final error = jsonDecode(response.body)['error'];
        print('Failed to unreserve locker: $error');
        throw Exception('Failed to unreserve locker: $error');
      } else {
        throw Exception(
            'Failed to unreserve locker: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in unreserveLocker: $e');
      throw Exception('Failed to unreserve locker');
    }
  }

  Future<bool> registerUser(String email, String password, String fullName,
      String phoneNumber) async {
    final String _baseUrl = 'https://beta.masterofthings.com/safeguard_lockers';

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Auth': {
          'DriverManagerId': '1',
          'DriverManagerPassword': '123',
        },
        'email': email,
        'password': password,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      print("success");

      return true;
    } else {
      // Handle registration failure
      print(fullName + phoneNumber + email + password);
      return false;
    }
  }

  Future<int?> loginUser(String email, String password) async {
    final String _baseUrl = 'https://beta.masterofthings.com/safeguard_lockers';

    final body = jsonEncode({
      'Auth': {
        'DriverManagerId': '1',
        'DriverManagerPassword': '123',
      },
      'email': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // Check if the response is a valid JSON string
      if (json.decode(response.body) is String) {
        int userId = int.parse(json.decode(response.body));
        // Return the user ID from the response
        return userId;
      } else {
        // Handle unexpected response format
        return null;
      }
    } else {
      // Handle login failure
      return null;
    }
  }

// In api_service.dart

  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://beta.masterofthings.com/GetAppReadingValueList'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'AppId': 195,
          'ConditionList': [
            {
              'Reading': 'email',
              'Condition': 'e',
              'Value': email,
            },
          ],
          'Auth': {
            'Key':
            'XzeIpngQu7AjlKir1688050464151Locker_Management_System_Use_Data',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['Result'];
        if (data.isNotEmpty) {
          return User.fromJson(data[0]);
        } else {
          print('Failed to load the user. Empty result.');
          return null;
        }
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
