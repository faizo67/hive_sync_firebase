import 'package:hive_sync_firebase/domain/repositories/device_info_repository.dart';

class GetClockStream {
  final DeviceInfoRepository repository;
  GetClockStream(this.repository);

  Stream<String> call() => repository.getClockStream();
}
