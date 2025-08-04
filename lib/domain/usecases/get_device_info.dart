import 'package:hive_sync_firebase/domain/entities/device_info_entity.dart';
import 'package:hive_sync_firebase/domain/repositories/device_info_repository.dart';

class GetDeviceInfo {
  final DeviceInfoRepository repository;
  GetDeviceInfo(this.repository);

  Future<DeviceInfoEntity> call() => repository.getDeviceInfo();
}
