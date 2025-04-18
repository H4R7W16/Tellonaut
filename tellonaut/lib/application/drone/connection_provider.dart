import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/drone/drone_repository_impl.dart';

final droneRepositoryProvider = Provider<DroneRepositoryImpl>(
  (ref) => DroneRepositoryImpl(),
);

enum ConnectionStatus { disconnected, connecting, connected, error }

class ConnectionNotifier extends StateNotifier<ConnectionStatus> {
  ConnectionNotifier(this._repo) : super(ConnectionStatus.disconnected);
  final DroneRepositoryImpl _repo;

  Future<void> connect() async {
    if (state == ConnectionStatus.connected) return;
    state = ConnectionStatus.connecting;
    try {
      await _repo.connect();
      state = ConnectionStatus.connected;
    } catch (_) {
      state = ConnectionStatus.error;
    }
  }

  Future<void> disconnect() async {
    await _repo.disconnect();
    state = ConnectionStatus.disconnected;
  }

  Future<void> takeOff() => _repo.sendCommand('takeoff');
  Future<void> land() => _repo.sendCommand('land');
}

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, ConnectionStatus>(
      (ref) => ConnectionNotifier(ref.read(droneRepositoryProvider)),
    );
