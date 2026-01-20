// lib/features/tasks/presentation/widgets/priority_chip_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_filter_chip.dart'; 

// specialized widget to handle priority filtering logic
class PriorityChipWidget extends StatelessWidget {
  final String label;
  final TaskPriority? priority;
  final TaskState state;

  const PriorityChipWidget({
    super.key,
    required this.label,
    required this.priority,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Determines if this specific priority filter is currently active
    final isSelected = state.priorityFilter == priority;
    
    return TaskFilterChip(
      label: label,
      isSelected: isSelected,
      onTap: () {
        // Dispatches event to update the priority filter in the BLoC
        context.read<TaskBloc>().add(TaskPriorityFilterChanged(priority));
      },
    );
  }
}