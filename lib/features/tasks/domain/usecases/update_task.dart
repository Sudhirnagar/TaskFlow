import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

// Encapsulates the business logic for modifying an existing task's details
class UpdateTask implements UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  // Executes the repository operation to save changes to the task
  @override
  Future<dartz.Either<Failure, Task>> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task);
  }
}

// Container for the task entity containing the updated values
class UpdateTaskParams {
  final Task task;

  UpdateTaskParams({required this.task});
}