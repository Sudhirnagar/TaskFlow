import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../pages/task_detail_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'task_item.dart';

// Widget responsible for rendering a group of tasks under a specific header (e.g., "Today")
class TaskSectionWidget extends StatelessWidget {
  final String title;
  final List<Task> allTasks;

  const TaskSectionWidget({
    super.key,
    required this.title,
    required this.allTasks,
  });

  // Filters the master list of tasks to show only those relevant to the current section
  List<Task> _getTasksBySection(List<Task> tasks, String section) {
    switch (section) {
      case 'Today':
        return tasks.where((task) => DateFormatter.isToday(task.dueDate)).toList();
      case 'Tomorrow':
        return tasks.where((task) => DateFormatter.isTomorrow(task.dueDate)).toList();
      case 'This week':
        return tasks
            .where((task) =>
                DateFormatter.isThisWeek(task.dueDate) &&
                !DateFormatter.isToday(task.dueDate) &&
                !DateFormatter.isTomorrow(task.dueDate))
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the specific tasks for this section
    final sectionTasks = _getTasksBySection(allTasks, title);

    // If no tasks exist for this section, hide the widget entirely
    if (sectionTasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        // Map tasks to Dismissible items
        ...sectionTasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Dismissible(
            key: Key(task.id),
            
            //Right Swipe (StartToEnd) -> Complete Action (Green background)
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.check_circle, color: Colors.white, size: 30),
            ),

            //Left Swipe (EndToStart) -> Delete Action (Red background)
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),

            // Handle the swipe action
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // Complete Task
                context.read<TaskBloc>().add(TaskToggleCompletionRequested(task));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task Completed! 🎉'), duration: Duration(seconds: 1)),
                );
              } else {
                // Delete Task
                context.read<TaskBloc>().add(TaskDeleteRequested(task.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task Deleted'), duration: Duration(seconds: 1)),
                );
              }
            },

            // The actual Task Item UI
            child: TaskItem(
              task: task,
              onTap: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskDetailPage(
                        userId: authState.user.id,
                        task: task,
                      ),
                    ),
                  );
                }
              },
              onToggle: () => context.read<TaskBloc>().add(TaskToggleCompletionRequested(task)),
              onDelete: () => context.read<TaskBloc>().add(TaskDeleteRequested(task.id)),
            ),
          ),
        )),
      ],
    );
  }
}