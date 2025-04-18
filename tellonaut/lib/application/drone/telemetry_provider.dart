import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connection_provider.dart';
import '../../domain/drone/models/drone_state.dart';

final telemetryProvider = StreamProvider<DroneState>((ref) {
  final repo = ref.watch(droneRepositoryProvider);
  return repo.telemetry$;
});
