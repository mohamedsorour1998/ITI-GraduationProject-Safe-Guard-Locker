// available_lockers_page.dart

import 'package:flutter/material.dart';
import '../models/locker.dart';
import '../screens/locker_details_page.dart';
import '../widgets/locker_card.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AvailableLockersPage extends StatefulWidget {
  final User user;

  AvailableLockersPage({required this.user});

  @override
  _AvailableLockersPageState createState() => _AvailableLockersPageState();
}

class _AvailableLockersPageState extends State<AvailableLockersPage> {
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService

  Future<List<Locker>>? _availableLockersFuture;

  @override
  void initState() {
    super.initState();
    _availableLockersFuture = apiService.getAvailableLockers();
  }

  void _refreshLockers() {
    setState(() {
      _availableLockersFuture = apiService.getAvailableLockers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Lockers'),
      ),
      body: FutureBuilder<List<Locker>>(
        future: _availableLockersFuture, // Fetch available lockers from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            String errorDetails =
                snapshot.error.toString(); // Get the error details
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load available lockers'),
                  SizedBox(height: 8),
                  Text(
                      'Error details: $errorDetails'), // Display the error details
                ],
              ),
            );
          } else {
            final availableLockers = snapshot.data;
            print(widget.user);
            return GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: availableLockers!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final locker = availableLockers[index];

                return LockerCard(
                  locker: locker,
                  user: widget.user, // Pass the user object
                  onTap: _refreshLockers, // Pass the _refreshLockers callback
                );
              },
            );
          }
        },
      ),
    );
  }
}