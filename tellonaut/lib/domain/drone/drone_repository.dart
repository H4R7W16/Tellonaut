import 'models/drone_state.dart';

abstract class DroneRepository {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendCommand(String command);

  /// laufender Telemetrie‑Datenstrom
  Stream<DroneState> get telemetry$;
}
