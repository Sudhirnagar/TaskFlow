// lib/features/tasks/domain/repositories/task_repository.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

// Domain contract defining available task operations independent of implementation
abstract class TaskRepository {
  // Retrieves a list of tasks for a specific user
  Future<dartz.Either<Failure, List<Task>>> getTasks(String userId);

  // Creates a new task and returns the created entity
  Future<dartz.Either<Failure, Task>> createTask(Task task);

  // Updates an existing task and returns the updated entity
  Future<dartz.Either<Failure, Task>> updateTask(Task task);

  // Permanently deletes a task by its ID
  Future<dartz.Either<Failure, void>> deleteTask(String taskId);

  // Provides a real-time stream of the user's tasks
  Stream<List<Task>> watchTasks(String userId);
}