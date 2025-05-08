// lib/presentation/screens/live_control_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/drone/connection_provider.dart';
import '../../application/drone/telemetry_provider.dart';
import '../widgets/joystick_control.dart';

enum FlightMode { modeA, modeB }

typedef DroneMapping = DroneJoystickMapping;

class LiveControlScreen extends ConsumerStatefulWidget {
  const LiveControlScreen({super.key});

  @override
  ConsumerState<LiveControlScreen> createState() => _LiveControlScreenState();
}

class _LiveControlScreenState extends ConsumerState<LiveControlScreen> {
  bool showTelemetry = false;
  FlightMode mode = FlightMode.modeA;

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionProvider);
    final telemetry = ref.watch(telemetryProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Control'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Connect / Disconnect Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              icon: Icon(
                connectionState == ConnectionStatus.connected
                    ? Icons.wifi
                    : Icons.wifi_off,
              ),
              label: Text(
                connectionState == ConnectionStatus.connected
                    ? 'Disconnect'
                    : 'Connect',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: connectionState == ConnectionStatus.connected
                    ? Colors.red
                    : Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () {
                final notifier = ref.read(connectionProvider.notifier);
                if (connectionState == ConnectionStatus.connected) {
                  notifier.disconnect();
                } else {
                  notifier.connect();
                }
              },
            ),
          ),
          // Telemetry toggle
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Telemetry',
            onPressed: () => setState(() => showTelemetry = !showTelemetry),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video feed area
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'Video Feed',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                ),
                if (showTelemetry && telemetry != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(80),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Battery: ${telemetry.battery}%'),
                          Text('Height: ${telemetry.height} cm'),
                          Text('TOF: ${telemetry.tof} cm'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Control region
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Joystick row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      JoystickControl(
                        isLeft: true,
                        mapping: mode == FlightMode.modeA
                            ? DroneMapping.throttleYaw
                            : DroneMapping.rollPitch,
                      ),
                      JoystickControl(
                        isLeft: false,
                        mapping: mode == FlightMode.modeA
                            ? DroneMapping.rollPitch
                            : DroneMapping.throttleYaw,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mode toggle and flips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        isSelected: [
                          mode == FlightMode.modeA,
                          mode == FlightMode.modeB,
                        ],
                        onPressed: (index) => setState(() {
                          mode = index == 0
                              ? FlightMode.modeA
                              : FlightMode.modeB;
                        }),
                        children: const [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Mode A'),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Mode B'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      // Flip buttons
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_upward),
                            tooltip: 'Front Flip',
                            onPressed: () => ref
                                .read(connectionProvider.notifier)
                                .flip('front'),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            tooltip: 'Left Flip',
                            onPressed: () => ref
                                .read(connectionProvider.notifier)
                                .flip('left'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            tooltip: 'Right Flip',
                            onPressed: () => ref
                                .read(connectionProvider.notifier)
                                .flip('right'),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            icon: const Icon(Icons.arrow_downward),
                            tooltip: 'Back Flip',
                            onPressed: () => ref
                                .read(connectionProvider.notifier)
                                .flip('back'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Emergency / Takeoff / Land / Stream row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => _confirmEmergency(),
                        child: const Text('Emergency'),
                      ),
                      ElevatedButton(
                        onPressed: connectionState == ConnectionStatus.connected
                            ? () => ref
                                .read(connectionProvider.notifier)
                                .takeOff()
                            : null,
                        child: const Text('Takeoff'),
                      ),
                      ElevatedButton(
                        onPressed: connectionState == ConnectionStatus.connected
                            ? () => ref
                                .read(connectionProvider.notifier)
                                .land()
                            : null,
                        child: const Text('Land'),
                      ),
                      ElevatedButton(
                        onPressed: connectionState == ConnectionStatus.connected
                            ? () {/* toggle stream */}
                            : null,
                        child: const Text('Stream'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmEmergency() {
    // Implement slide-to-confirm emergency stop dialog
  }
}
