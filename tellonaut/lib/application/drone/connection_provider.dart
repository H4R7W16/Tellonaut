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
      await _repo.sendCommand('command'); // SDK‑Mode sicherstellen
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
  /// Führt einen Flip in eine der vier Richtungen aus: 'front', 'back', 'left', 'right'.
  Future<void> flip(String direction) =>
    _repo.sendCommand('flip $direction');
  /// RC‑Tuple als **benanntes** Record
  Future<void> sendRC(({int lr, int fb, int ud, int yw}) v) =>
      _repo.sendCommand('rc ${v.lr} ${v.fb} ${v.ud} ${v.yw}');
}

final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, ConnectionStatus>(
      (ref) => ConnectionNotifier(ref.read(droneRepositoryProvider)),
    );
