import 'package:freezed_annotation/freezed_annotation.dart';

part 'drone_state.freezed.dart';
part 'drone_state.g.dart';

@freezed
class DroneState with _$DroneState {
  const factory DroneState({
    @Default(false) bool connected, // Verbindung steht?
    int? battery, // %
    int? height, // cm  (h)
    int? tof, // cm  (Time‑of‑Flight)
    int? pitch,
    int? roll,
    int? yaw,
  }) = _DroneState;

  factory DroneState.fromJson(Map<String, dynamic> json) =>
      _$DroneStateFromJson(json);
}
