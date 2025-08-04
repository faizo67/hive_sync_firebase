import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_sync_firebase/domain/usecases/get_clock_stream.dart';
import 'package:hive_sync_firebase/domain/usecases/get_device_info.dart';
import 'package:hive_sync_firebase/presentation/bloc/device_info/device_info_event.dart';
import 'package:hive_sync_firebase/presentation/bloc/device_info/device_info_state.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  final GetDeviceInfo getDeviceInfo;
  final GetClockStream getClockStream;

  DeviceInfoBloc(this.getDeviceInfo, this.getClockStream)
    : super(DeviceInfoInitial()) {
    on<LoadDeviceInfoEvent>(_onLoad);
    on<ClockTickEvent>(_onClockTick);

    // Start clock stream
    getClockStream().call().listen((time) {
      add(ClockTickEvent(time));
    });
  }

  Future<void> _onLoad(
    LoadDeviceInfoEvent event,
    Emitter<DeviceInfoState> emit,
  ) async {
    emit(DeviceInfoLoading());
    try {
      final info = await getDeviceInfo();
      emit(DeviceInfoLoaded(infoEntity: info, clock: "--:--:--"));
    } catch (e) {
      emit(DeviceInfoError(e.toString()));
    }
  }

  void _onClockTick(ClockTickEvent event, Emitter<DeviceInfoState> emit) {
    if (state is DeviceInfoLoaded) {
      final loaded = state as DeviceInfoLoaded;
      emit(DeviceInfoLoaded(infoEntity: loaded.infoEntity, clock: event.time));
    }
  }
}
