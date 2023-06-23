// A custom widget for displaying a locker's details in a card format.

import 'package:flutter/material.dart';
import '../models/locker.dart';
import '../services/api_service.dart';

class LockerCard extends StatelessWidget {
  final Locker locker;
  final VoidCallback onTap;
  final ApiService apiService =
      ApiService(); // Create an instance of ApiService

  LockerCard({required this.locker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: locker.isAvailable ? onTap : null,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    locker.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text('ID: ${locker.id}'),
                SizedBox(height: 8),
                Text(
                    'Status: ${locker.isAvailable ? 'Available' : 'Not Available'}'),
                SizedBox(height: 8),
                Text('Size: ${locker.size}'),
                SizedBox(height: 8),
                Text('Price: \$${locker.price}'),
                SizedBox(height: 8),
                locker.isAvailable
                    ? ElevatedButton(
                        // onPressed: () async {
                        //   // Call the reserveLocker function when the button is clicked
                        //   await apiService.reserveLocker(locker.id as int);
                        //   // Call onTap to refresh the parent widget
                        //   onTap();
                        // },
                        onPressed: onTap,

                        child: Text('Reserve Now'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 36),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text('Reserved!'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 36),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
