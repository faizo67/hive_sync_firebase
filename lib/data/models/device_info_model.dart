import 'package:hive_sync_firebase/domain/entities/device_info_entity.dart';

class DeviceInfoModel extends DeviceInfoEntity {
  DeviceInfoModel({
    required super.battery,
    required super.free,
    required super.total,
  });

  factory DeviceInfoModel.fromNative(
    int battery,
    Map<String, dynamic> storage,
  ) {
    return DeviceInfoModel(
      battery: battery,
      free: storage['free'],
      total: storage['total'],
    );
  }
}
