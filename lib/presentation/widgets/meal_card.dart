import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  const MealCard({super.key, required this.meal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant,
              color: AppTheme.primaryGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatTime(meal.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.calories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildMacroIcon('🥩', meal.protein),
                  const SizedBox(width: 8),
                  _buildMacroIcon('🌾', meal.carbs),
                  const SizedBox(width: 8),
                  _buildMacroIcon('🥑', meal.fat),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroIcon(String emoji, double value) {
    return Text(
      '$emoji ${value.toStringAsFixed(0)}',
      style: const TextStyle(fontSize: 12),
    );
  }
}
