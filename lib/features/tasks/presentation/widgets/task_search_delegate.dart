// lib/features/tasks/presentation/widgets/task_search_delegate.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../pages/task_detail_page.dart';
import 'task_item.dart';

class TaskSearchDelegate extends SearchDelegate {
  final TaskBloc taskBloc;
  final String userId;

  TaskSearchDelegate({
    required this.taskBloc,
    required this.userId,
  });

  // Action buttons on the right of the search bar (e.g., Clear query)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  // Leading icon on the left of the search bar (e.g., Back button)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // View shown when the user hits 'Enter' or 'Search'
  @override
  Widget buildResults(BuildContext context) {
    return _buildLiveList();
  }

  // View shown dynamically as the user types
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildLiveList();
  }

  // specialized method using BlocBuilder to ensure search results update 
  // in real-time if a task is modified or deleted within the search view
  Widget _buildLiveList() {
    return BlocBuilder<TaskBloc, TaskState>(
      bloc: taskBloc, 
      builder: (context, state) {
        // Filter the current state based on the search query
        final filteredTasks = state.tasks.where((task) {
          final titleLower = task.title.toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower);
        }).toList();

        // Empty State
        if (filteredTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  query.isEmpty ? 'Search for a task...' : 'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        // Search Results List
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TaskItem(
                task: task,
                
                // Navigate to detail page on tap
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailPage(
                        userId: userId,
                        task: task,
                      ),
                    ),
                  );
                },

                // Dispatch toggle event directly to the existing BLoC
                onToggle: () {
                   taskBloc.add(TaskToggleCompletionRequested(task));
                },

                // Dispatch delete event directly to the existing BLoC
                onDelete: () {
                   taskBloc.add(TaskDeleteRequested(task.id));
                },
              ),
            );
          },
        );
      },
    );
  }
}