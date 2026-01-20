// lib/features/tasks/presentation/pages/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/task_search_delegate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_item.dart';
import 'task_detail_page.dart';

import '../widgets/priority_chip_widget.dart';
import '../widgets/task_section_widget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch tasks as soon as the dashboard loads
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(TaskLoadRequested(authState.user.id));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: const Text('Logout',
                  style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for logout events to redirect to Login Page
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthAuthenticated && state is! AuthLoading) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        // Centered FAB for adding new tasks
        floatingActionButton: Container(
          height: 65,
          width: 65,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) =>
                          TaskDetailPage(userId: authState.user.id)),
                );
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Custom Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(0),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 15,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: Icon(Icons.format_list_bulleted_rounded,
                    size: 30,
                    color: _selectedIndex == 0
                        ? AppColors.primary
                        : Colors.grey.shade400),
                tooltip: 'My Tasks',
              ),
              const SizedBox(width: 48),
              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: Icon(Icons.calendar_today_rounded,
                    size: 28,
                    color: _selectedIndex == 1
                        ? AppColors.primary
                        : Colors.grey.shade400),
                tooltip: 'Completed',
              ),
            ],
          ),
        ),

        // Switch between Active Tasks and Completed Tasks views
        body: _selectedIndex == 0 ? _buildMyTasksView() : _buildCompletedView(),
      ),
    );
  }

  // --- View 1: Active Tasks (Dashboard) ---
  Widget _buildMyTasksView() {
    return Column(
      children: [
        _buildHeader(isCompletedPage: false),
        Expanded(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              final activeTasks = taskState.filteredTasks
                  .where((task) => !task.isCompleted)
                  .toList();

              return Column(
                children: [
                  // Horizontal Priority Filters
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PriorityChipWidget(
                              label: 'All', priority: null, state: taskState),
                          const SizedBox(width: 8),
                          PriorityChipWidget(
                              label: AppStrings.low,
                              priority: TaskPriority.low,
                              state: taskState),
                          const SizedBox(width: 8),
                          PriorityChipWidget(
                              label: AppStrings.medium,
                              priority: TaskPriority.medium,
                              state: taskState),
                          const SizedBox(width: 8),
                          PriorityChipWidget(
                              label: AppStrings.high,
                              priority: TaskPriority.high,
                              state: taskState),
                        ],
                      ),
                    ),
                  ),
                  
                  // Grouped Task List
                  Expanded(
                    child: taskState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : activeTasks.isEmpty
                            ? _buildEmptyState('No active tasks')
                            : ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  TaskSectionWidget(
                                      title: 'Today', allTasks: activeTasks),
                                  TaskSectionWidget(
                                      title: 'Tomorrow', allTasks: activeTasks),
                                  TaskSectionWidget(
                                      title: 'This week',
                                      allTasks: activeTasks),
                                  const SizedBox(height: 80),
                                ],
                              ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- View 2: Completed Tasks History ---
  Widget _buildCompletedView() {
    return Column(
      children: [
        _buildHeader(isCompletedPage: true),
        Expanded(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              final completedTasks =
                  taskState.tasks.where((task) => task.isCompleted).toList();
              if (taskState.isLoading)
                return const Center(child: CircularProgressIndicator());
              if (completedTasks.isEmpty)
                return _buildEmptyState('No completed tasks yet');

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  // Completed tasks can be deleted or unchecked
                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    background: Container(color: Colors.red),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) => context
                        .read<TaskBloc>()
                        .add(TaskDeleteRequested(task.id)),
                    child: TaskItem(
                      task: task,
                      onTap: () {},
                      onToggle: () => context
                          .read<TaskBloc>()
                          .add(TaskToggleCompletionRequested(task)),
                      onDelete: () => context
                          .read<TaskBloc>()
                          .add(TaskDeleteRequested(task.id)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Common Header with Search and Date
  Widget _buildHeader({required bool isCompletedPage}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation and Search Bar Row
              Row(
                children: [
                  // App Icon / Dashboard Toggle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.grid_view_rounded,
                        color: Colors.white),
                  ),

                  const SizedBox(width: 12),

                  // Search Bar Trigger
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final taskBloc = context.read<TaskBloc>();
                        final authBloc = context.read<AuthBloc>().state;

                        if (authBloc is AuthAuthenticated) {
                          showSearch(
                            context: context,
                            delegate: TaskSearchDelegate(
                              taskBloc: taskBloc,
                              userId: authBloc.user.id,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: Colors.grey, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Search tasks...',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Logout Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Date and Page Title
              Text(
                'Today, ${DateFormat('d MMMM').format(DateTime.now())}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Text(
                isCompletedPage ? 'Completed' : AppStrings.myTasks,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Placeholder for empty lists
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}