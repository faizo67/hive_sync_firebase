import 'package:hive_sync_firebase/core/platform/native_channel_service.dart';
import 'package:hive_sync_firebase/data/models/device_info_model.dart';
import 'package:hive_sync_firebase/domain/entities/device_info_entity.dart';
import 'package:hive_sync_firebase/domain/repositories/device_info_repository.dart';

class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final NativeChannelService service;

  DeviceInfoRepositoryImpl(this.service);

  @override
  Future<DeviceInfoEntity> getDeviceInfo() async {
    final battery = await service.getBatteryLevel();
    final storage = await service.getStorageInfo();
    return DeviceInfoModel.fromNative(battery, storage);
  }

  @override
  Stream<String> getClockStream() {
    return service.getClockStream();
  }
}
