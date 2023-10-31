import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

  class MQTTManager {
  final String _host = 'broker.hivemq.com';
  final int _port = 1883;
  final String _clientId = 'clientId-UXSnbxzbEH';
  final String _topic;

  late MqttServerClient _client;

  MQTTManager(this._topic) {
    _client = MqttServerClient(_host, _clientId);
    _client.port = _port;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.pongCallback = _pong;
    _client.logging(on: false);
  }

  Future<void> connect() async {
    try {
      await _client.connect();
    } catch (e) {
      print('Exception: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected.');
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${_client.connectionStatus!.state}');
      _client.disconnect();
    }
  }

  void subscribe() {
    print('Subscribing to $_topic');
    _client.subscribe(_topic, MqttQos.atMostOnce);
  }

  void publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void _onConnected() {
    print('Connected to MQTT broker.');
  }

  bool isConnected() {
    return _client.connectionStatus!.state == MqttConnectionState.connected;
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker.');
  }

  void _pong() {
    print('Ping response client callback invoked');
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }
}
