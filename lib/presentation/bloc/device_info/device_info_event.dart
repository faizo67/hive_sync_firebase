abstract class DeviceInfoEvent {}

class LoadDeviceInfoEvent extends DeviceInfoEvent {}

class ClockTickEvent extends DeviceInfoEvent {
  final String time;
  ClockTickEvent(this.time);
}
