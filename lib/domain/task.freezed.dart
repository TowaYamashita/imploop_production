// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TaskTearOff {
  const _$TaskTearOff();

  _Task call(
      {required int taskId,
      required String name,
      required int statusId,
      required int taskTypeId}) {
    return _Task(
      taskId: taskId,
      name: name,
      statusId: statusId,
      taskTypeId: taskTypeId,
    );
  }
}

/// @nodoc
const $Task = _$TaskTearOff();

/// @nodoc
mixin _$Task {
  int get taskId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get statusId => throw _privateConstructorUsedError;
  int get taskTypeId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res>;
  $Res call({int taskId, String name, int statusId, int taskTypeId});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res> implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  final Task _value;
  // ignore: unused_field
  final $Res Function(Task) _then;

  @override
  $Res call({
    Object? taskId = freezed,
    Object? name = freezed,
    Object? statusId = freezed,
    Object? taskTypeId = freezed,
  }) {
    return _then(_value.copyWith(
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as int,
      taskTypeId: taskTypeId == freezed
          ? _value.taskTypeId
          : taskTypeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) then) =
      __$TaskCopyWithImpl<$Res>;
  @override
  $Res call({int taskId, String name, int statusId, int taskTypeId});
}

/// @nodoc
class __$TaskCopyWithImpl<$Res> extends _$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(_Task _value, $Res Function(_Task) _then)
      : super(_value, (v) => _then(v as _Task));

  @override
  _Task get _value => super._value as _Task;

  @override
  $Res call({
    Object? taskId = freezed,
    Object? name = freezed,
    Object? statusId = freezed,
    Object? taskTypeId = freezed,
  }) {
    return _then(_Task(
      taskId: taskId == freezed
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      statusId: statusId == freezed
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as int,
      taskTypeId: taskTypeId == freezed
          ? _value.taskTypeId
          : taskTypeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Task extends _Task {
  const _$_Task(
      {required this.taskId,
      required this.name,
      required this.statusId,
      required this.taskTypeId})
      : super._();

  @override
  final int taskId;
  @override
  final String name;
  @override
  final int statusId;
  @override
  final int taskTypeId;

  @override
  String toString() {
    return 'Task(taskId: $taskId, name: $name, statusId: $statusId, taskTypeId: $taskTypeId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Task &&
            const DeepCollectionEquality().equals(other.taskId, taskId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.statusId, statusId) &&
            const DeepCollectionEquality()
                .equals(other.taskTypeId, taskTypeId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(taskId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(statusId),
      const DeepCollectionEquality().hash(taskTypeId));

  @JsonKey(ignore: true)
  @override
  _$TaskCopyWith<_Task> get copyWith =>
      __$TaskCopyWithImpl<_Task>(this, _$identity);
}

abstract class _Task extends Task {
  const factory _Task(
      {required int taskId,
      required String name,
      required int statusId,
      required int taskTypeId}) = _$_Task;
  const _Task._() : super._();

  @override
  int get taskId;
  @override
  String get name;
  @override
  int get statusId;
  @override
  int get taskTypeId;
  @override
  @JsonKey(ignore: true)
  _$TaskCopyWith<_Task> get copyWith => throw _privateConstructorUsedError;
}
