// lib/features/tasks/domain/usecases/toggle_task_completion.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class ToggleTaskCompletion implements UseCase<Task, ToggleTaskCompletionParams> {
  final TaskRepository repository;

  ToggleTaskCompletion(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(ToggleTaskCompletionParams params) async {
    final updatedTask = params.task.copyWith(
      isCompleted: !params.task.isCompleted,
      updatedAt: DateTime.now(),
    );
    return await repository.updateTask(updatedTask);
  }
}

class ToggleTaskCompletionParams {
  final Task task;

  ToggleTaskCompletionParams({required this.task});
}
