// available_lockers_page.dart

import 'package:flutter/material.dart';
import '../models/locker.dart';
import '../screens/locker_details_page.dart';
import '../widgets/locker_card.dart';
import '../services/api_service.dart';

class AvailableLockersPage extends StatelessWidget {
  final List<Locker> _availableLockers = [
    Locker(
        id: '1',
        name: 'Locker 1',
        isAvailable: true,
        size: 'Large',
        price: 90,
        imageUrl:
            'https://m.media-amazon.com/images/I/51TuSJOwO1L._AC_UL320_.jpg',
        userId: 1),

    Locker(
        id: '2',
        name: 'Locker 2',
        isAvailable: false,
        size: 'Medium',
        price: 70,
        imageUrl:
            'https://m.media-amazon.com/images/I/51s3ebenFDL._AC_UL320_.jpg',
        userId: 2),
    // Add more lockers as needed
  ];
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Lockers'),
      ),
      body: FutureBuilder<List<Locker>>(
        future: apiService
            .getAvailableLockers(), // Fetch available lockers from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError) {
            //   return Center(child: Text('Failed to load available lockers'));
          } else {
            // final availableLockers = snapshot.data;

            return GridView.builder(
              padding: EdgeInsets.all(16),
              // itemCount: availableLockers!.length,
              itemCount: _availableLockers!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                // final locker = availableLockers[index]; // Use the available lockers from the API
                final locker = _availableLockers[
                    index]; // Use the available lockers from the local list
                return LockerCard(
                    locker: locker,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              LockerDetailsPage(locker: locker),
                        ),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }
}
