import 'package:hive_sync_firebase/domain/entities/device_info_entity.dart';

abstract class DeviceInfoState {}

class DeviceInfoInitial extends DeviceInfoState {}

class DeviceInfoLoading extends DeviceInfoState {}

class DeviceInfoLoaded extends DeviceInfoState {
  final DeviceInfoEntity infoEntity;
  final String clock;

  DeviceInfoLoaded({required this.infoEntity, required this.clock});
}

class DeviceInfoError extends DeviceInfoState {
  final String message;
  DeviceInfoError(this.message);
}
