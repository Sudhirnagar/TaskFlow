// lib/features/tasks/domain/usecases/update_task.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask implements UseCase<Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task);
  }
}

class UpdateTaskParams {
  final Task task;

  UpdateTaskParams({required this.task});
}
