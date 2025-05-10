// lib/presentation/widgets/joystick_control.dart

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/drone/rc_controller.dart';

/// Internes Enum für das Mapping (Throttle/Yaw vs. Roll/Pitch).
enum DroneJoystickMapping { throttleYaw, rollPitch }

/// Joystick-Widget, das Steuerbefehle an den `rcProvider` schickt.
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
        listener: (details) {
          // details.x/details.y liegen in [-1, 1]
          if (isLeft) {
            ref.read(rcProvider.notifier)
               .setLeft(details.x, details.y);
          } else {
            ref.read(rcProvider.notifier)
               .setRight(details.x, details.y);
          }
        },
        // Rücksetz-Callback bei Loslassen des Joysticks
        onStickDragEnd: () {
          ref.read(rcProvider.notifier).release();
        },
        // Default-Intervall des Widgets verwenden
      ),
    );
  }
}
