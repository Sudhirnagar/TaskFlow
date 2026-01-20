// lib/features/tasks/domain/usecases/get_tasks.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks implements UseCase<List<Task>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<dartz.Either<Failure, List<Task>>> call(GetTasksParams params) async {
    return await repository.getTasks(params.userId);
  }
}

class GetTasksParams {
  final String userId;

  GetTasksParams({required this.userId});
}
