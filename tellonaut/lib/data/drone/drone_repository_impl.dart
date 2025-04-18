// impl. Drone repository
import 'dart:async';

import '../../domain/drone/drone_repository.dart';
import '../../domain/drone/models/drone_state.dart';
import 'udp_client.dart';
import 'telemetry_parser.dart';

class DroneRepositoryImpl implements DroneRepository {
  final _client = UdpClient.instance;

  @override
  Future<void> connect() => _client.open();

  @override
  Future<void> disconnect() => _client.close();

  @override
  Future<void> sendCommand(String command) => _client.send(command);

  @override
  Stream<DroneState> get telemetry$ =>
      _client.rawState$.map(parseState).asBroadcastStream();
}
