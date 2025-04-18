import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connection_provider.dart';

/// Benanntes Record für Klarheit
typedef RcValues = ({int lr, int fb, int ud, int yw});

final rcProvider = StateNotifierProvider<RCController, RcValues>((ref) {
  final conn = ref.read(connectionProvider.notifier);
  return RCController(conn);
});

class RCController extends StateNotifier<RcValues> {
  RCController(this._conn) : super((lr: 0, fb: 0, ud: 0, yw: 0));

  final ConnectionNotifier _conn;
  Timer? _timer;

  void _start() {
    _timer ??= Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _conn.sendRC(state),
    );
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    state = (lr: 0, fb: 0, ud: 0, yw: 0);
    _conn.sendRC(state);
  }

  /// linker Joystick – Roll (lr) & Pitch (fb)
  void setLeft(double x, double y) {
    state = (
      lr: (x * 100).round(),
      fb: (-y * 100).round(),
      ud: state.ud,
      yw: state.yw,
    );
    _start();
  }

  /// rechter Joystick – Throttle (ud) & Yaw (yw)
  void setRight(double x, double y) {
    state = (
      lr: state.lr,
      fb: state.fb,
      ud: (-y * 100).round(),
      yw: (x * 100).round(),
    );
    _start();
  }

  void release() => _stop();
}
