// lib/features/tasks/data/repositories/task_repository_impl.dart
import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<dartz.Either<Failure, List<Task>>> getTasks(String userId) async {
    try {
      final tasks = await remoteDataSource.getTasks(userId);
      return dartz.Right(tasks);
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } catch (e) {
      return dartz.Left(ServerFailure('An  error occurred'));
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: '',
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
      );
      final createdTask = await remoteDataSource.createTask(taskModel);
      return dartz.Right(createdTask);
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } catch (e) {
      return dartz.Left(ServerFailure('Failed to create task'));
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
        updatedAt: task.updatedAt,
      );
      final updatedTask = await remoteDataSource.updateTask(taskModel);
      return dartz.Right(updatedTask);
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } catch (e) {
      return dartz.Left(ServerFailure('Failed to update task'));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const dartz.Right(null);
    } on ServerException catch (e) {
      return dartz.Left(ServerFailure(e.message));
    } catch (e) {
      return dartz.Left(ServerFailure('Failed to delete task'));
    }
  }

  @override
  Stream<List<Task>> watchTasks(String userId) {
    return remoteDataSource.watchTasks(userId);
  }
}
