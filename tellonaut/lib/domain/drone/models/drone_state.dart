import 'package:freezed_annotation/freezed_annotation.dart';

part 'drone_state.freezed.dart';
part 'drone_state.g.dart';

@freezed
class DroneState with _$DroneState {
  const factory DroneState({
    // Verbindung steht? – Default: false
    @Default(false) bool connected,

    int? battery, // %
    int? height, // cm (h)
    int? tof, // cm (Time of Flight Sensor)
    int? pitch,
    int? roll,
    int? yaw,
  }) = _DroneState;

  factory DroneState.fromJson(Map<String, dynamic> json) =>
      _$DroneStateFromJson(json);
}
