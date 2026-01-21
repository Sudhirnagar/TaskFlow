import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

// Encapsulates the business logic for retrieving all tasks associated with a specific user
class GetTasks implements UseCase<List<Task>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  // Executes the repository operation to fetch the list of tasks
  @override
  Future<dartz.Either<Failure, List<Task>>> call(GetTasksParams params) async {
    return await repository.getTasks(params.userId);
  }
}

// Container for the user ID required to filter tasks
class GetTasksParams {
  final String userId;

  GetTasksParams({required this.userId});
}