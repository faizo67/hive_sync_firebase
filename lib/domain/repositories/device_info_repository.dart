import 'package:hive_sync_firebase/domain/entities/device_info_entity.dart';

abstract class DeviceInfoRepository {
  Future<DeviceInfoEntity> getDeviceInfo();
  Stream<String> getClockStream();
}
