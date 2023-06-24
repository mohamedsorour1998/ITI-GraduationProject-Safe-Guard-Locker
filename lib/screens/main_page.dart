import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import 'available_lockers_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _loggedInEmail;
  final ApiService apiService = ApiService();

  void _updateLoggedInEmail(String? email) {
    setState(() {
      _loggedInEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Guard Locker'),
        actions: [
          if (_loggedInEmail != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  'Welcome $_loggedInEmail',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          if (_loggedInEmail != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _updateLoggedInEmail(null);
              },
            )
          else
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () async {
                final email = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
                print(
                    'Received email from navigator: $email'); // Add this print statement
                if (email != null) {
                  _updateLoggedInEmail(email);
                }
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Available Lockers'),
              onPressed: _loggedInEmail != null
                  ? () async {
                      // Retrieve the User object associated with the logged-in email
                      User? user =
                          await apiService.getUserByEmail(_loggedInEmail!);

                      if (user != null) {
                        // Pass the User object when navigating to the AvailableLockersPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AvailableLockersPage(user: user),
                          ),
                        );
                      } else {
                        // Handle the case when the user object is null
                        print('Error: User object is null');
                      }
                    }
                  : null,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Safe Guard Locker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _loggedInEmail != null
                  ? 'Please select "Available Lockers" to view and manage lockers.'
                  : 'Please login to see Available Lockers',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
