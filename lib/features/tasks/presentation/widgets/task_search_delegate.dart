import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ Import Zaroori hai BlocBuilder ke liye
import '../../domain/entities/task.dart';
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
    // tasks list ki zaroorat nahi hai kyunki hum direct Bloc se fresh data lenge
  });

  // 1. Right Side (Clear Button)
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

  // 2. Left Side (Back Button)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // 3. Results View
  @override
  Widget buildResults(BuildContext context) {
    return _buildLiveList();
  }

  // 4. Suggestions View
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildLiveList();
  }

  // --- Main List Logic (Updated with BlocBuilder) ---
  Widget _buildLiveList() {
    // 🟢 BlocBuilder ka use kar rahe hain taaki UI update ho sake
    return BlocBuilder<TaskBloc, TaskState>(
      bloc: taskBloc, // Jo bloc humne pass kiya wo use karein
      builder: (context, state) {
        
        // Fresh Data se filter karein
        final filteredTasks = state.tasks.where((task) {
          final titleLower = task.title.toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower);
        }).toList();

        // Agar koi result na mile
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

        // Live List View
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TaskItem(
                task: task,
                
                // Navigate to Edit
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

                // ✅ Complete Toggle (Ab ye UI update karega)
                onToggle: () {
                   taskBloc.add(TaskToggleCompletionRequested(task));
                },

                // Delete Task
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