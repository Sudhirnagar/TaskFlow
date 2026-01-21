import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

// Filter options for the main tab view
enum TaskFilter { all, completed, incomplete }

class TaskState extends Equatable {
  final List<Task> tasks;          // All tasks fetched from the source
  final List<Task> filteredTasks;  // Tasks currently visible in the UI
  final TaskFilter filter;         // Current tab selection
  
  // Selected priority filter (Low/Medium/High). Null implies no priority filter is active.
  final TaskPriority? priorityFilter; 
  
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.filter = TaskFilter.all,
    this.priorityFilter, // Default is null (show all priorities)
    this.isLoading = false,
    this.errorMessage,
  });

  // Creates a copy of the state with updated values. 
  // Includes explicit flags (clearPriorityFilter, clearError) to handle setting nullable fields to null.
  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    TaskFilter? filter,
    TaskPriority? priorityFilter,
    bool clearPriorityFilter = false, // specific flag to reset priority filter to null
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,          // specific flag to clear error messages
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filter: filter ?? this.filter,
      // If clear flag is true, force null. Otherwise, use new value or fallback to existing.
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