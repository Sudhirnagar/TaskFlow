import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_filter_chip.dart'; // Make sure ye file exist karti ho

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
    // Check agar ye priority selected hai
    final isSelected = state.priorityFilter == priority;
    
    return TaskFilterChip(
      label: label,
      isSelected: isSelected,
      onTap: () {
        context.read<TaskBloc>().add(TaskPriorityFilterChanged(priority));
      },
    );
  }
}