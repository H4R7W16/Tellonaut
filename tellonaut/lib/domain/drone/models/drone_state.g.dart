// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drone_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DroneState _$DroneStateFromJson(Map<String, dynamic> json) => _DroneState(
  connected: json['connected'] as bool? ?? false,
  battery: (json['battery'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  tof: (json['tof'] as num?)?.toInt(),
  pitch: (json['pitch'] as num?)?.toInt(),
  roll: (json['roll'] as num?)?.toInt(),
  yaw: (json['yaw'] as num?)?.toInt(),
);

Map<String, dynamic> _$DroneStateToJson(_DroneState instance) =>
    <String, dynamic>{
      'connected': instance.connected,
      'battery': instance.battery,
      'height': instance.height,
      'tof': instance.tof,
      'pitch': instance.pitch,
      'roll': instance.roll,
      'yaw': instance.yaw,
    };
