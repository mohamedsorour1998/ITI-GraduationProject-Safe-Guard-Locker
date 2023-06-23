import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  Future<void> connect() async {
    _setupMqttClient();
    await _connectClient();
  }

  Future<void> disconnect() async {
    client!.disconnect();
  }

  void subscribe(String topic) {
    _subscribeToTopic(topic);
  }

  void publish(String topic, String message) {
    _publishMessage(topic, message);
  }

  Future<void> _connectClient() async {
    try {
      print('Client connecting...');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client!.connect('mohamedsorour', 'mohamedsorour');
    } on Exception catch (e) {
      print('Client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client!.disconnect();
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('Client connected');
    } else {
      print('ERROR: Client connection failed - disconnecting, status is ${client!.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client!.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort('ed899a39c5d048d1923b57ae79773860.s2.eu.hivemq.cloud', 'mohamedsorour', 8883);
    client!.secure = true;
    client!.securityContext = SecurityContext.defaultContext;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client!.subscribe(topicName, MqttQos.atMostOnce);
  }

  void _publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $topic');
    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was successful');
  }
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED
}