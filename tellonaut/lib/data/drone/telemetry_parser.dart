import '../../domain/drone/models/drone_state.dart';

DroneState parseState(String raw) {
  // Beispiel‑String: pitch:0;roll:0;yaw:0;bat:92;h:12;tof:89;
  final map = <String, String>{};
  for (final pair in raw.trim().split(';')) {
    if (pair.contains(':')) {
      final kv = pair.split(':');
      map[kv[0]] = kv[1];
    }
  }
  return DroneState(
    battery: int.tryParse(map['bat'] ?? ''),
    height: int.tryParse(map['h'] ?? ''),
    tof: int.tryParse(map['tof'] ?? ''),
    pitch: int.tryParse(map['pitch'] ?? ''),
    roll: int.tryParse(map['roll'] ?? ''),
    yaw: int.tryParse(map['yaw'] ?? ''),
  );
}
