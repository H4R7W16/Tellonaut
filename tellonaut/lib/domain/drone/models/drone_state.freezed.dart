// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drone_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DroneState {

// Verbindung steht? – Default: false
 bool get connected; int? get battery;// %
 int? get height;// cm (h)
 int? get tof;// cm (Time of Flight Sensor)
 int? get pitch; int? get roll; int? get yaw;
/// Create a copy of DroneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DroneStateCopyWith<DroneState> get copyWith => _$DroneStateCopyWithImpl<DroneState>(this as DroneState, _$identity);

  /// Serializes this DroneState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DroneState&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.height, height) || other.height == height)&&(identical(other.tof, tof) || other.tof == tof)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.roll, roll) || other.roll == roll)&&(identical(other.yaw, yaw) || other.yaw == yaw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connected,battery,height,tof,pitch,roll,yaw);

@override
String toString() {
  return 'DroneState(connected: $connected, battery: $battery, height: $height, tof: $tof, pitch: $pitch, roll: $roll, yaw: $yaw)';
}


}

/// @nodoc
abstract mixin class $DroneStateCopyWith<$Res>  {
  factory $DroneStateCopyWith(DroneState value, $Res Function(DroneState) _then) = _$DroneStateCopyWithImpl;
@useResult
$Res call({
 bool connected, int? battery, int? height, int? tof, int? pitch, int? roll, int? yaw
});




}
/// @nodoc
class _$DroneStateCopyWithImpl<$Res>
    implements $DroneStateCopyWith<$Res> {
  _$DroneStateCopyWithImpl(this._self, this._then);

  final DroneState _self;
  final $Res Function(DroneState) _then;

/// Create a copy of DroneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connected = null,Object? battery = freezed,Object? height = freezed,Object? tof = freezed,Object? pitch = freezed,Object? roll = freezed,Object? yaw = freezed,}) {
  return _then(_self.copyWith(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,tof: freezed == tof ? _self.tof : tof // ignore: cast_nullable_to_non_nullable
as int?,pitch: freezed == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int?,roll: freezed == roll ? _self.roll : roll // ignore: cast_nullable_to_non_nullable
as int?,yaw: freezed == yaw ? _self.yaw : yaw // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DroneState implements DroneState {
  const _DroneState({this.connected = false, this.battery, this.height, this.tof, this.pitch, this.roll, this.yaw});
  factory _DroneState.fromJson(Map<String, dynamic> json) => _$DroneStateFromJson(json);

// Verbindung steht? – Default: false
@override@JsonKey() final  bool connected;
@override final  int? battery;
// %
@override final  int? height;
// cm (h)
@override final  int? tof;
// cm (Time of Flight Sensor)
@override final  int? pitch;
@override final  int? roll;
@override final  int? yaw;

/// Create a copy of DroneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DroneStateCopyWith<_DroneState> get copyWith => __$DroneStateCopyWithImpl<_DroneState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DroneStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DroneState&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.height, height) || other.height == height)&&(identical(other.tof, tof) || other.tof == tof)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.roll, roll) || other.roll == roll)&&(identical(other.yaw, yaw) || other.yaw == yaw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connected,battery,height,tof,pitch,roll,yaw);

@override
String toString() {
  return 'DroneState(connected: $connected, battery: $battery, height: $height, tof: $tof, pitch: $pitch, roll: $roll, yaw: $yaw)';
}


}

/// @nodoc
abstract mixin class _$DroneStateCopyWith<$Res> implements $DroneStateCopyWith<$Res> {
  factory _$DroneStateCopyWith(_DroneState value, $Res Function(_DroneState) _then) = __$DroneStateCopyWithImpl;
@override @useResult
$Res call({
 bool connected, int? battery, int? height, int? tof, int? pitch, int? roll, int? yaw
});




}
/// @nodoc
class __$DroneStateCopyWithImpl<$Res>
    implements _$DroneStateCopyWith<$Res> {
  __$DroneStateCopyWithImpl(this._self, this._then);

  final _DroneState _self;
  final $Res Function(_DroneState) _then;

/// Create a copy of DroneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connected = null,Object? battery = freezed,Object? height = freezed,Object? tof = freezed,Object? pitch = freezed,Object? roll = freezed,Object? yaw = freezed,}) {
  return _then(_DroneState(
connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,tof: freezed == tof ? _self.tof : tof // ignore: cast_nullable_to_non_nullable
as int?,pitch: freezed == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int?,roll: freezed == roll ? _self.roll : roll // ignore: cast_nullable_to_non_nullable
as int?,yaw: freezed == yaw ? _self.yaw : yaw // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
