// lib/features/tasks/domain/usecases/create_task.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

// Encapsulates the business logic for adding a new task to the system
class CreateTask implements UseCase<Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  // Executes the repository operation to save the new task
  @override
  Future<dartz.Either<Failure, Task>> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

// Container for the task entity required to perform the create operation
class CreateTaskParams {
  final Task task;

  CreateTaskParams({required this.task});
}