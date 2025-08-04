import 'package:flutter/services.dart';

class NativeChannelService {
  static const _method = MethodChannel('com.example.device/method');
  static const _event = EventChannel('com.example.device/clock');

  Future<int> getBatteryLevel() async {
    return await _method.invokeMethod('getBatteryLevel');
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    return Map<String, dynamic>.from(
      await _method.invokeMethod('getStorageInfo'),
    );
  }

  Stream<String> getClockStream() {
    return _event.receiveBroadcastStream().map((e) => e.toString());
  }
}
