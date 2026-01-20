// lib/features/tasks/presentation/bloc/task_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/toggle_task_completion.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTaskCompletion toggleTaskCompletion;
  final TaskRepository taskRepository;

  // ignore: unused_field
  String? _currentUserId;

  TaskBloc({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskCompletion,
    required this.taskRepository,
  }) : super(const TaskState()) {
    on<TaskLoadRequested>(_onTaskLoadRequested);
    on<TaskCreateRequested>(_onTaskCreateRequested);
    on<TaskUpdateRequested>(_onTaskUpdateRequested);
    on<TaskDeleteRequested>(_onTaskDeleteRequested);
    on<TaskToggleCompletionRequested>(_onTaskToggleCompletionRequested);
    on<TaskFilterChanged>(_onTaskFilterChanged);
    
    // ✅ Use Changed (Set), not Toggle
    on<TaskPriorityFilterChanged>(_onTaskPriorityFilterChanged);
  }

  Future<void> _onTaskLoadRequested(
    TaskLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    _currentUserId = event.userId;

    await emit.forEach<List<Task>>(
      taskRepository.watchTasks(event.userId),
      onData: (tasks) {
        final sortedTasks = _sortTasks(tasks);
        final filteredTasks = _applyFilters(
          sortedTasks, 
          state.filter, 
          state.priorityFilter // ✅ Use single filter
        );
        
        return state.copyWith(
          tasks: sortedTasks,
          filteredTasks: filteredTasks,
          isLoading: false,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load tasks',
        );
      },
    );
  }

  Future<void> _onTaskCreateRequested(TaskCreateRequested event, Emitter<TaskState> emit) async {
    final result = await createTask(CreateTaskParams(task: event.task));
    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (_) {});
  }

  Future<void> _onTaskUpdateRequested(TaskUpdateRequested event, Emitter<TaskState> emit) async {
    final result = await updateTask(UpdateTaskParams(task: event.task));
    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (_) {});
  }

  Future<void> _onTaskDeleteRequested(TaskDeleteRequested event, Emitter<TaskState> emit) async {
    final result = await deleteTask(DeleteTaskParams(taskId: event.taskId));
    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (_) {});
  }

  Future<void> _onTaskToggleCompletionRequested(TaskToggleCompletionRequested event, Emitter<TaskState> emit) async {
    final result = await toggleTaskCompletion(ToggleTaskCompletionParams(task: event.task));
    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (_) {});
  }

  void _onTaskFilterChanged(TaskFilterChanged event, Emitter<TaskState> emit) {
    final filteredTasks = _applyFilters(state.tasks, event.filter, state.priorityFilter);
    emit(state.copyWith(filter: event.filter, filteredTasks: filteredTasks));
  }

  // ✅ Simple Set Logic
  void _onTaskPriorityFilterChanged(
    TaskPriorityFilterChanged event,
    Emitter<TaskState> emit,
  ) {
    final filteredTasks = _applyFilters(
      state.tasks,
      state.filter,
      event.priority,
    );
    
    emit(state.copyWith(
      priorityFilter: event.priority,
      filteredTasks: filteredTasks,
      clearPriorityFilter: event.priority == null, // Clear if null passed
    ));
  }

  List<Task> _sortTasks(List<Task> tasks) {
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sortedTasks;
  }

  List<Task> _applyFilters(
    List<Task> tasks,
    TaskFilter filter,
    TaskPriority? priorityFilter,
  ) {
    var filtered = tasks;

    switch (filter) {
      case TaskFilter.completed:
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.incomplete:
        filtered = filtered.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    if (priorityFilter != null) {
      filtered = filtered.where((task) => task.priority == priorityFilter).toList();
    }

    return filtered;
  }
}