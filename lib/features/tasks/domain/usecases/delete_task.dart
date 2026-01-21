import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

// Encapsulates the business logic for permanently removing a task
class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  // Executes the repository operation to delete the task by ID
  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async {
    return await repository.deleteTask(params.taskId);
  }
}

// Container for the task ID required to identify the record
class DeleteTaskParams {
  final String taskId;

  DeleteTaskParams({required this.taskId});
}