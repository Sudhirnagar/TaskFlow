// lib/features/tasks/presentation/bloc/task_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart'; 
import 'task_state.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class TaskLoadRequested extends TaskEvent {
  final String userId;
  const TaskLoadRequested(this.userId);
  @override
  List<Object> get props => [userId];
}

class TaskCreateRequested extends TaskEvent {
  final Task task;
  const TaskCreateRequested(this.task);
  @override
  List<Object> get props => [task];
}

class TaskUpdateRequested extends TaskEvent {
  final Task task;
  const TaskUpdateRequested(this.task);
  @override
  List<Object> get props => [task];
}

class TaskDeleteRequested extends TaskEvent {
  final String taskId;
  const TaskDeleteRequested(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class TaskToggleCompletionRequested extends TaskEvent {
  final Task task;
  const TaskToggleCompletionRequested(this.task);
  @override
  List<Object> get props => [task];
}

class TaskFilterChanged extends TaskEvent {
  final TaskFilter filter;
  const TaskFilterChanged(this.filter);
  @override
  List<Object> get props => [filter];
}

// ✅ FIX: Single Priority Change Event (Nullable allow karein)
class TaskPriorityFilterChanged extends TaskEvent {
  final TaskPriority? priority; 
  const TaskPriorityFilterChanged(this.priority);
  @override
  List<Object?> get props => [priority];
}