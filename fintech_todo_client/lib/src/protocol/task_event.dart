/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'task.dart' as _i2;

abstract class TaskEvent implements _i1.SerializableModel {
  TaskEvent._({
    this.id,
    required this.type,
    required this.task,
  });

  factory TaskEvent({
    int? id,
    required String type,
    required _i2.Task task,
  }) = _TaskEventImpl;

  factory TaskEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskEvent(
      id: jsonSerialization['id'] as int?,
      type: jsonSerialization['type'] as String,
      task: _i2.Task.fromJson(
          (jsonSerialization['task'] as Map<String, dynamic>)),
    );
  }

  String type;

  _i2.Task task;

  int? id;

  /// Returns a shallow copy of this [TaskEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskEvent copyWith({
    int? id,
    String? type,
    _i2.Task? task,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'task': task.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskEventImpl extends TaskEvent {
  _TaskEventImpl({
    int? id,
    required String type,
    required _i2.Task task,
  }) : super._(
          id: id,
          type: type,
          task: task,
        );

  /// Returns a shallow copy of this [TaskEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskEvent copyWith({
    Object? id = _Undefined,
    String? type,
    _i2.Task? task,
  }) {
    return TaskEvent(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      task: task ?? this.task.copyWith(),
    );
  }
}
