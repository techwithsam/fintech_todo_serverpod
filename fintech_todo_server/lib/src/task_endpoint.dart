import 'package:fintech_todo_server/src/exceptions.dart';
import 'package:fintech_todo_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class TaskEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // CREATE
  Future<Task> createTask(Session session, Task request) async {
    final auth = await session.authenticated;

    if (auth == null) {
      throw AuthorizationException(message: "You're not authenticated!");
    }
    final userId = auth.userId;

    // Validation
    if (request.title.isEmpty) {
      throw ValidationException(message: "Title cannot be empty");
    }

    if (request.amount <= 0) {
      throw ValidationException(message: "Amount must be greater than zero");
    }

    final task = Task(
      userId: userId,
      title: request.title,
      amount: request.amount,
      description: request.description,
      dueDate: request.dueDate,
    );

    final inserted = await Task.db.insertRow(session, task);
    return inserted;
  }

  // READ
  Future<List<Task>> getTasks(Session session) async {
    final auth = await session.authenticated;

    if (auth == null) {
      throw AuthorizationException(message: "You're not authenticated!");
    }
    final userId = auth.userId;

    final tasks = await Task.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.dueDate,
      orderDescending: true,
    );
    return tasks;
  }

  // UPDATE
  Future<Task> updateTask(Session session, Task request) async {
    final auth = await session.authenticated;

    if (auth == null) {
      throw AuthorizationException(message: "You're not authenticated!");
    }
    final userId = auth.userId;

    if (request.id == null) {
      throw ValidationException(message: "Task ID is required for update");
    }

    if (request.title.isEmpty) {
      throw ValidationException(message: "Title cannot be empty");
    }

    if (request.amount <= 0) {
      throw ValidationException(message: "Amount must be greater than zero");
    }

    final existingTask = await Task.db.findById(session, request.id!);

    if (existingTask == null) {
      throw NotFoundException(message: "Task with ID ${request.id} not found.");
    }
    if (existingTask.userId != userId) {
      throw AuthorizationException(
          message: "You do not have permission to update this task.");
    }

    final updatedTask = existingTask.copyWith(
      title: request.title,
      amount: request.amount,
      description: request.description,
      dueDate: request.dueDate,
    );

    final result = await Task.db.updateRow(session, updatedTask);
    return result;
  }

  // DELETE
  Future<void> deleteTask(Session session, int taskId) async {
    final auth = await session.authenticated;

    if (auth == null) {
      throw AuthorizationException(message: "You're not authenticated!");
    }
    final userId = auth.userId;

    final rowsDeleted = await Task.db.deleteWhere(
      session,
      where: (t) => t.id.equals(taskId) & t.userId.equals(userId),
    );

    if (rowsDeleted.isEmpty) {
      throw NotFoundException(message: "Task with ID $taskId not found.");
    }
  }
}
