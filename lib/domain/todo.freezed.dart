// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TodoTearOff {
  const _$TodoTearOff();

  _Todo call(
      {required int todoId,
      required int taskId,
      required String name,
      required int statusId,
      required int todoTypeId,
      required int estimate,
      int? elapsed}) {
    return _Todo(
      todoId: todoId,
      taskId: taskId,
      name: name,
      statusId: statusId,
      todoTypeId: todoTypeId,
      estimate: estimate,
      elapsed: elapsed,
    );
  }
}

/// @nodoc
const $Todo = _$TodoTearOff();

/// @nodoc
mixin _$Todo {
  int get todoId => throw _privateConstructorUsedError;
  int get taskId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get statusId => throw _privateConstructorUsedError;
  int get todoTypeId => throw _privateConstructorUsedError;
  int get estimate => throw _privateConstructorUsedError;
  int? get elapsed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodoCopyWith<Todo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoCopyWith<$Res> {
  factory $TodoCopyWith(Todo value, $Res Function(Todo) then) =
      _$TodoCopyWithImpl<$Res>;
  $Res call(
      {int todoId,
      int taskId,
      String name,
      int statusId,
      int todoTypeId,
      int estimate,
      int? elapsed});
}

/// @nodoc
class _$TodoCopyWithImpl<$Res> implements $TodoCopyWith<$Res> {
  _$TodoCopyWithImpl(this._value, this._then);

  final Todo _value;
  // ignore: unused_field
  final $Res Function(Todo) _then;

  @override
  $Res call({
    Object? todoId = freezed,
    Object? taskId = freezed,
    Object? name = freezed,
    Object? statusId = freezed,
    Object? todoTypeId = freezed,
    Object? estimate = freezed,
    Object? elapsed = freezed,
  }) {
    return _then(_value.copyWith(
      todoId: todoId == freezed
          ? _value.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
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
      todoTypeId: todoTypeId == freezed
          ? _value.todoTypeId
          : todoTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      estimate: estimate == freezed
          ? _value.estimate
          : estimate // ignore: cast_nullable_to_non_nullable
              as int,
      elapsed: elapsed == freezed
          ? _value.elapsed
          : elapsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$TodoCopyWith<$Res> implements $TodoCopyWith<$Res> {
  factory _$TodoCopyWith(_Todo value, $Res Function(_Todo) then) =
      __$TodoCopyWithImpl<$Res>;
  @override
  $Res call(
      {int todoId,
      int taskId,
      String name,
      int statusId,
      int todoTypeId,
      int estimate,
      int? elapsed});
}

/// @nodoc
class __$TodoCopyWithImpl<$Res> extends _$TodoCopyWithImpl<$Res>
    implements _$TodoCopyWith<$Res> {
  __$TodoCopyWithImpl(_Todo _value, $Res Function(_Todo) _then)
      : super(_value, (v) => _then(v as _Todo));

  @override
  _Todo get _value => super._value as _Todo;

  @override
  $Res call({
    Object? todoId = freezed,
    Object? taskId = freezed,
    Object? name = freezed,
    Object? statusId = freezed,
    Object? todoTypeId = freezed,
    Object? estimate = freezed,
    Object? elapsed = freezed,
  }) {
    return _then(_Todo(
      todoId: todoId == freezed
          ? _value.todoId
          : todoId // ignore: cast_nullable_to_non_nullable
              as int,
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
      todoTypeId: todoTypeId == freezed
          ? _value.todoTypeId
          : todoTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      estimate: estimate == freezed
          ? _value.estimate
          : estimate // ignore: cast_nullable_to_non_nullable
              as int,
      elapsed: elapsed == freezed
          ? _value.elapsed
          : elapsed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_Todo extends _Todo {
  const _$_Todo(
      {required this.todoId,
      required this.taskId,
      required this.name,
      required this.statusId,
      required this.todoTypeId,
      required this.estimate,
      this.elapsed})
      : super._();

  @override
  final int todoId;
  @override
  final int taskId;
  @override
  final String name;
  @override
  final int statusId;
  @override
  final int todoTypeId;
  @override
  final int estimate;
  @override
  final int? elapsed;

  @override
  String toString() {
    return 'Todo(todoId: $todoId, taskId: $taskId, name: $name, statusId: $statusId, todoTypeId: $todoTypeId, estimate: $estimate, elapsed: $elapsed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Todo &&
            const DeepCollectionEquality().equals(other.todoId, todoId) &&
            const DeepCollectionEquality().equals(other.taskId, taskId) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.statusId, statusId) &&
            const DeepCollectionEquality()
                .equals(other.todoTypeId, todoTypeId) &&
            const DeepCollectionEquality().equals(other.estimate, estimate) &&
            const DeepCollectionEquality().equals(other.elapsed, elapsed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(todoId),
      const DeepCollectionEquality().hash(taskId),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(statusId),
      const DeepCollectionEquality().hash(todoTypeId),
      const DeepCollectionEquality().hash(estimate),
      const DeepCollectionEquality().hash(elapsed));

  @JsonKey(ignore: true)
  @override
  _$TodoCopyWith<_Todo> get copyWith =>
      __$TodoCopyWithImpl<_Todo>(this, _$identity);
}

abstract class _Todo extends Todo {
  const factory _Todo(
      {required int todoId,
      required int taskId,
      required String name,
      required int statusId,
      required int todoTypeId,
      required int estimate,
      int? elapsed}) = _$_Todo;
  const _Todo._() : super._();

  @override
  int get todoId;
  @override
  int get taskId;
  @override
  String get name;
  @override
  int get statusId;
  @override
  int get todoTypeId;
  @override
  int get estimate;
  @override
  int? get elapsed;
  @override
  @JsonKey(ignore: true)
  _$TodoCopyWith<_Todo> get copyWith => throw _privateConstructorUsedError;
}
