import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../models/locker.dart';
import '../services/mqtt_service.dart';
import '../models/user.dart';

class LockerDetailsPage extends StatefulWidget {
  final Locker locker;
  final User user;

  LockerDetailsPage({required this.locker, required this.user});

  @override
  _LockerDetailsPageState createState() => _LockerDetailsPageState();
}

class _LockerDetailsPageState extends State<LockerDetailsPage> {
  MqttService _mqttService = MqttService();
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _mqttService.connect().then((_) {
      print('MQTT connected!');

      if (_mqttService.client != null) {
        String lockerStatusTopic = 'lockers/${widget.locker.id}/status';
        _mqttService.subscribe(lockerStatusTopic);

        if (_mqttService.client!.updates != null) {
          _mqttService.client!.updates!
              .listen((List<MqttReceivedMessage<MqttMessage>> c) {
            final MqttPublishMessage recMess =
                c[0].payload as MqttPublishMessage;
            final String payload = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message!);
            setState(() {
              if (payload == 'LOCKED') {
                _isLocked = true;
              } else if (payload == 'UNLOCKED') {
                _isLocked = false;
              }
            });
          });
        } else {
          print('Error: MQTT client updates stream is null');
        }
      } else {
        print('Error: MQTT client is not initialized');
      }
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.locker.id"),

      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) => true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    widget.locker.imageUrl,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Locker ID:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(widget.locker.id.toString()), SizedBox(height: 20),
                Text(
                  'Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(widget.locker.isAvailable
                    ? 'Available'
                    : 'Available only for me'),
                SizedBox(height: 20),
                Text(
                  'Size:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(widget.locker.size),
                SizedBox(height: 20),
                Text(
                  'Price:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('\$${widget.locker.price}'),
                SizedBox(height: 20),
                // SizedBox(height: 20),
                // Text(
                //   'Reserved by:',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 5),
                // Text(widget.user
                //     .email), // Show the email of the user who reserved the locker
                // SizedBox(height: 20),
                ElevatedButton(
                  child: Text(_isLocked ? 'Unlock' : 'Lock'),
                  onPressed: () {
                    setState(() {
                      _isLocked = !_isLocked;
                    });
                    // Implement lock/unlock functionality here
                    String message = _isLocked ? 'UNLOCK' : 'LOCK';
                    String topic = _isLocked
                        ? 'lockers/${widget.locker.id}/unlock'
                        : 'lockers/${widget.locker.id}/lock';

                    if (_mqttService.client != null) {
                      _mqttService.client!.publishMessage(
                          topic,
                          MqttQos.atLeastOnce,
                          MqttClientPayloadBuilder()
                              .addString(message)
                              .payload!);
                    } else {
                      print('Error: MQTT client is not initialized');
                    }
                  },
                )
                // : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
