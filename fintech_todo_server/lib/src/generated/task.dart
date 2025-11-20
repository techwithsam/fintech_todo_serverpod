/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Task implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Task._({
    this.id,
    required this.title,
    required this.description,
    required this.amount,
    this.dueDate,
    required this.userId,
  });

  factory Task({
    int? id,
    required String title,
    required String description,
    required double amount,
    DateTime? dueDate,
    required int userId,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      userId: jsonSerialization['userId'] as int,
    );
  }

  static final t = TaskTable();

  static const db = TaskRepository._();

  @override
  int? id;

  String title;

  String description;

  double amount;

  DateTime? dueDate;

  int userId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Task copyWith({
    int? id,
    String? title,
    String? description,
    double? amount,
    DateTime? dueDate,
    int? userId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'userId': userId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'userId': userId,
    };
  }

  static TaskInclude include() {
    return TaskInclude._();
  }

  static TaskIncludeList includeList({
    _i1.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskTable>? orderByList,
    TaskInclude? include,
  }) {
    return TaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Task.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Task.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required String title,
    required String description,
    required double amount,
    DateTime? dueDate,
    required int userId,
  }) : super._(
          id: id,
          title: title,
          description: description,
          amount: amount,
          dueDate: dueDate,
          userId: userId,
        );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    String? title,
    String? description,
    double? amount,
    Object? dueDate = _Undefined,
    int? userId,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      userId: userId ?? this.userId,
    );
  }
}

class TaskTable extends _i1.Table<int?> {
  TaskTable({super.tableRelation}) : super(tableName: 'task') {
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
  }

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnDateTime dueDate;

  late final _i1.ColumnInt userId;

  @override
  List<_i1.Column> get columns => [
        id,
        title,
        description,
        amount,
        dueDate,
        userId,
      ];
}

class TaskInclude extends _i1.IncludeObject {
  TaskInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Task.t;
}

class TaskIncludeList extends _i1.IncludeList {
  TaskIncludeList._({
    _i1.WhereExpressionBuilder<TaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Task.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Task.t;
}

class TaskRepository {
  const TaskRepository._();

  /// Returns a list of [Task]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Task>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Task] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Task?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskTable>? where,
    int? offset,
    _i1.OrderByBuilder<TaskTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Task] by its [id] or null if no such row exists.
  Future<Task?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Task>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Task]s in the list and returns the inserted rows.
  ///
  /// The returned [Task]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Task>> insert(
    _i1.Session session,
    List<Task> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Task>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Task] and returns the inserted row.
  ///
  /// The returned [Task] will have its `id` field set.
  Future<Task> insertRow(
    _i1.Session session,
    Task row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Task>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Task]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Task>> update(
    _i1.Session session,
    List<Task> rows, {
    _i1.ColumnSelections<TaskTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Task>(
      rows,
      columns: columns?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Task]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Task> updateRow(
    _i1.Session session,
    Task row, {
    _i1.ColumnSelections<TaskTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Task>(
      row,
      columns: columns?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Task]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Task>> delete(
    _i1.Session session,
    List<Task> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Task>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Task].
  Future<Task> deleteRow(
    _i1.Session session,
    Task row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Task>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Task>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TaskTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Task>(
      where: where(Task.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Task>(
      where: where?.call(Task.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
