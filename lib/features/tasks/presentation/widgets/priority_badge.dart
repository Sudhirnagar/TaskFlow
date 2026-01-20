// lib/features/tasks/presentation/widgets/priority_badge.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/task.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool isSmall;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.isSmall = false,
  });

  Color get _color {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.lowPriority;
      case TaskPriority.medium:
        return AppColors.mediumPriority;
      case TaskPriority.high:
        return AppColors.highPriority;
    }
  }

  String get _label {
    switch (priority) {
      case TaskPriority.low:
        return AppStrings.low;
      case TaskPriority.medium:
        return AppStrings.medium;
      case TaskPriority.high:
        return AppStrings.high;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: isSmall ? 12 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
