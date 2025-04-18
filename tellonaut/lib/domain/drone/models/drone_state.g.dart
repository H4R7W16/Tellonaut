// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drone_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DroneState _$DroneStateFromJson(Map<String, dynamic> json) => _DroneState(
  battery: (json['battery'] as num).toInt(),
  connected: json['connected'] as bool,
  height: (json['height'] as num).toDouble(),
);

Map<String, dynamic> _$DroneStateToJson(_DroneState instance) =>
    <String, dynamic>{
      'battery': instance.battery,
      'connected': instance.connected,
      'height': instance.height,
    };
