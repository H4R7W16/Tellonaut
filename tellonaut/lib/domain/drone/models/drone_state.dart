import 'package:freezed_annotation/freezed_annotation.dart';

// Generierte Dateien
part 'drone_state.freezed.dart';
part 'drone_state.g.dart';

@freezed
class DroneState with _$DroneState {
  const factory DroneState({
    required int battery,
    required bool connected,
    required double height,
    // … weitere Felder hier
  }) = _DroneState;

  /// Factory für JSON‑Deserialisierung
  factory DroneState.fromJson(Map<String, dynamic> json) =>
      _$DroneStateFromJson(json);
}
