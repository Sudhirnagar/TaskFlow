// lib/features/tasks/domain/repositories/task_repository.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, List<Task>>> getTasks(String userId);
  Future<dartz.Either<Failure, Task>> createTask(Task task);
  Future<dartz.Either<Failure, Task>> updateTask(Task task);
  Future<dartz.Either<Failure, void>> deleteTask(String taskId);
  Stream<List<Task>> watchTasks(String userId);
}
