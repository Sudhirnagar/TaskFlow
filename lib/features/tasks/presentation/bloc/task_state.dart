// lib/features/tasks/presentation/bloc/task_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

enum TaskFilter { all, completed, incomplete }

class TaskState extends Equatable {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final TaskFilter filter;
  
  // ✅ FIX: Wapas single variable (List hata di hai)
  final TaskPriority? priorityFilter; 
  
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.filter = TaskFilter.all,
    this.priorityFilter, // Default null (All)
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    TaskFilter? filter,
    TaskPriority? priorityFilter, // Single Select
    bool clearPriorityFilter = false, // Special flag to clear filter
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filter: filter ?? this.filter,
      // Logic: Agar clear flag true hai toh null set karo, nahi toh naya value ya purana value
      priorityFilter: clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        filteredTasks,
        filter,
        priorityFilter,
        isLoading,
        errorMessage,
      ];
}