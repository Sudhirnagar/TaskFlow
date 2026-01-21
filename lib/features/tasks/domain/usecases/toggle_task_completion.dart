import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

// Encapsulates the logic for flipping a task's completion status
class ToggleTaskCompletion implements UseCase<Task, ToggleTaskCompletionParams> {
  final TaskRepository repository;

  ToggleTaskCompletion(this.repository);

  // Inverts the 'isCompleted' status and updates the modification timestamp
  @override
  Future<dartz.Either<Failure, Task>> call(ToggleTaskCompletionParams params) async {
    final updatedTask = params.task.copyWith(
      isCompleted: !params.task.isCompleted,
      updatedAt: DateTime.now(),
    );
    return await repository.updateTask(updatedTask);
  }
}

// Container for the task entity to be toggled
class ToggleTaskCompletionParams {
  final Task task;

  ToggleTaskCompletionParams({required this.task});
}