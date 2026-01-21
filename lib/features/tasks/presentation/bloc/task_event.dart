import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart'; 
import 'task_state.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

// Triggered when the user logs in or the screen initializes to fetch tasks
class TaskLoadRequested extends TaskEvent {
  final String userId;
  const TaskLoadRequested(this.userId);
  @override
  List<Object> get props => [userId];
}

// Triggered when the user submits a new task form
class TaskCreateRequested extends TaskEvent {
  final Task task;
  const TaskCreateRequested(this.task);
  @override
  List<Object> get props => [task];
}

// Triggered when the user saves edits to an existing task
class TaskUpdateRequested extends TaskEvent {
  final Task task;
  const TaskUpdateRequested(this.task);
  @override
  List<Object> get props => [task];
}

// Triggered when the user confirms deletion of a task
class TaskDeleteRequested extends TaskEvent {
  final String taskId;
  const TaskDeleteRequested(this.taskId);
  @override
  List<Object> get props => [taskId];
}

// Triggered when the user taps the checkbox on a task tile
class TaskToggleCompletionRequested extends TaskEvent {
  final Task task;
  const TaskToggleCompletionRequested(this.task);
  @override
  List<Object> get props => [task];
}

// Triggered when the user changes the main status tabs (All / Incomplete / Completed)
class TaskFilterChanged extends TaskEvent {
  final TaskFilter filter;
  const TaskFilterChanged(this.filter);
  @override
  List<Object> get props => [filter];
}

// Triggered when the user filters by priority chips (Low / Medium / High), allows null to reset
class TaskPriorityFilterChanged extends TaskEvent {
  final TaskPriority? priority; 
  const TaskPriorityFilterChanged(this.priority);
  @override
  List<Object?> get props => [priority];
}