import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/drone/rc_controller.dart';

class JoystickControl extends ConsumerWidget {
  const JoystickControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rc = ref.read(rcProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Joystick(
          listener: (d) => rc.setLeft(d.x, d.y),
          onStickDragEnd: (_) => rc.release(),
        ),
        Joystick(
          listener: (d) => rc.setRight(d.x, d.y),
          onStickDragEnd: (_) => rc.release(),
        ),
      ],
    );
  }
}
