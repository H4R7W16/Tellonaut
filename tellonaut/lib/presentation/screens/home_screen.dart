import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/drone/connection_provider.dart';
import '../../application/drone/telemetry_provider.dart';
import '../widgets/joystick_control.dart';
import 'programming_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connStatus = ref.watch(connectionProvider);
    final telemetry = ref.watch(telemetryProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tellonaut'),
        actions: [
          if (telemetry?.battery != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(label: Text('${telemetry!.battery}% 🔋')),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Status: $connStatus',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  connStatus == ConnectionStatus.disconnected
                      ? () => ref.read(connectionProvider.notifier).connect()
                      : null,
              child: const Text('Connect'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  connStatus == ConnectionStatus.connected
                      ? () => ref.read(connectionProvider.notifier).takeOff()
                      : null,
              child: const Text('Take‑off'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  connStatus == ConnectionStatus.connected
                      ? () => ref.read(connectionProvider.notifier).land()
                      : null,
              child: const Text('Land'),
            ),
            const SizedBox(height: 24),
            if (telemetry != null) ...[
              Text('Height: ${telemetry.height ?? '—'} cm'),
              Text('TOF: ${telemetry.tof ?? '—'} cm'),
            ],
            const SizedBox(height: 24),
            const JoystickControl(),
            if (telemetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  telemetry.toJson().toString(), // alles als Map anzeigen
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProgrammingScreen(),
                    ),
                  ),
              child: const Text('Programmieren'),
            ),
          ],
        ),
      ),
    );
  }
}
