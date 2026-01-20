
// lib/features/tasks/domain/usecases/delete_task.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) async {
    return await repository.deleteTask(params.taskId);
  }
}

class DeleteTaskParams {
  final String taskId;

  DeleteTaskParams({required this.taskId});
}
