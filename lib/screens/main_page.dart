// Displays the main page with the login and register buttons
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Guard Locker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
              Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage);
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
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.availableLockers);
              },
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
              'Please select "Available Lockers" to view and manage lockers.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
