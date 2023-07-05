import 'package:flutter/material.dart';
import '../models/locker.dart';
import '../screens/locker_details_page.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class LockerCard extends StatelessWidget {
  final Locker locker;
  final User user;

  final VoidCallback onTap;
  final ApiService apiService = ApiService();

  LockerCard({required this.locker, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isReservedByCurrentUser = locker.userId == user.id;
    bool isReservedByOtherUser =
        locker.userId != null && !isReservedByCurrentUser;

    return InkWell(
      onTap: locker.isAvailable ? onTap : null,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
    child: SingleChildScrollView( // Add this SingleChildScrollView

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
              if (!locker.isAvailable)
                FutureBuilder<String>(
                  future: apiService.getUserEmail(locker.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Reserved by: ${snapshot.data}');
                    }
                  },
                ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: isReservedByOtherUser
                    ? null
                    : () async {
                        if (locker.isAvailable) {
                          await apiService.reserveLocker(
                              locker.id , user.id );
                        } else if (isReservedByCurrentUser) {
                          await apiService.unreserveLocker(locker.id);
                        }
                        onTap();
                      },
                child: Text(isReservedByOtherUser
                    ? 'Can not reserve this locker as it is reserved by other user'
                    : (locker.isAvailable ? 'Reserve Now' : 'Unreserve')),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: isReservedByCurrentUser
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LockerDetailsPage(locker: locker, user: user),
                          ),
                        );
                      }
                    : null,
                child: Text(isReservedByCurrentUser
                    ? 'Control this locker'
                    : 'You must reserve the locker before controlling it'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
            ],
          ),
    ),
        ),
      ),
    );
  }
}