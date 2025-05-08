// lib/presentation/widgets/joystick_control.dart

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/drone/rc_controller.dart';

/// Mapping für Joystick-Achsenbelegung:
/// - throttleYaw: Linker Stick steuert Throttle/Yaw, rechter Stick Roll/Pitch  
/// - rollPitch:   Linker Stick steuert Roll/Pitch,   rechter Stick Throttle/Yaw
enum DroneJoystickMapping {
  throttleYaw,
  rollPitch,
}

/// Joystick-Widget, das alle 100 ms Steuerwerte an den rcProvider sendet.
class JoystickControl extends ConsumerWidget {
  final bool isLeft;
  final DroneJoystickMapping mapping;

  const JoystickControl({
    super.key,
    required this.isLeft,
    required this.mapping,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Joystick(
        mode: JoystickMode.horizontalAndVertical,
        period: const Duration(milliseconds: 100),
        listener: (details) {
          // details.x/details.y ∈ [-1, 1]; wir skalieren auf –100…100:
          final dx = (details.x * 100).round();
          final dy = (details.y * 100).round();

          // Je nach mapping drehen wir um:
          final leftShouldControlRollPitch =
              mapping == DroneJoystickMapping.rollPitch;

          // Welcher Stick soll jetzt Roll/Pitch senden?
          if (isLeft == leftShouldControlRollPitch) {
            // Aufruf von setLeft für Roll/Pitch oder Throttle/Yaw gemäß mapping
            ref.read(rcProvider.notifier).setLeft(details.x, details.y);
          } else {
            // Umgekehrt schickt der rechte Stick die anderen Werte
            ref.read(rcProvider.notifier).setRight(details.x, details.y);
          }
        },
        onStickDragEnd: () {
          ref.read(rcProvider.notifier).release();
        },
      ),
    );
  }
}
