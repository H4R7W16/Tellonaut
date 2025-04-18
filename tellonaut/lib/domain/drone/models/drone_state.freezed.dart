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

 int get battery; bool get connected; double get height;
/// Create a copy of DroneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DroneStateCopyWith<DroneState> get copyWith => _$DroneStateCopyWithImpl<DroneState>(this as DroneState, _$identity);

  /// Serializes this DroneState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DroneState&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,battery,connected,height);

@override
String toString() {
  return 'DroneState(battery: $battery, connected: $connected, height: $height)';
}


}

/// @nodoc
abstract mixin class $DroneStateCopyWith<$Res>  {
  factory $DroneStateCopyWith(DroneState value, $Res Function(DroneState) _then) = _$DroneStateCopyWithImpl;
@useResult
$Res call({
 int battery, bool connected, double height
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
@pragma('vm:prefer-inline') @override $Res call({Object? battery = null,Object? connected = null,Object? height = null,}) {
  return _then(_self.copyWith(
battery: null == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DroneState implements DroneState {
  const _DroneState({required this.battery, required this.connected, required this.height});
  factory _DroneState.fromJson(Map<String, dynamic> json) => _$DroneStateFromJson(json);

@override final  int battery;
@override final  bool connected;
@override final  double height;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DroneState&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,battery,connected,height);

@override
String toString() {
  return 'DroneState(battery: $battery, connected: $connected, height: $height)';
}


}

/// @nodoc
abstract mixin class _$DroneStateCopyWith<$Res> implements $DroneStateCopyWith<$Res> {
  factory _$DroneStateCopyWith(_DroneState value, $Res Function(_DroneState) _then) = __$DroneStateCopyWithImpl;
@override @useResult
$Res call({
 int battery, bool connected, double height
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
@override @pragma('vm:prefer-inline') $Res call({Object? battery = null,Object? connected = null,Object? height = null,}) {
  return _then(_DroneState(
battery: null == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
