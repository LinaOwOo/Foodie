import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/meal.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/meal_card.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final mealsNotifier = ref.read(mealsProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          _buildDailyStatsSummary(),
          const Divider(height: 1),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final meals = ref.watch(mealsProvider);

                if (meals.isEmpty) {
                  return _buildEmptyHistory();
                }

                return RefreshIndicator(
                  onRefresh: () => mealsNotifier.loadTodayMeals(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return MealCard(
                        meal: meal,
                        onDelete: () => mealsNotifier.deleteMeal(meal.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildDateButton(icon: Icons.chevron_left, onTap: _previousDay),
              const SizedBox(width: 8),
              _buildDateButton(icon: Icons.chevron_right, onTap: _nextDay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
      ),
    );
  }

  Widget _buildDailyStatsSummary() {
    return Consumer(
      builder: (context, ref, child) {
        final stats = ref.watch(dailyStatsProvider);

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildStatRow(
                'Calories',
                '${stats.consumedCalories.toStringAsFixed(0)} / ${stats.targetCalories.toStringAsFixed(0)}',
                'kcal',
                AppTheme.primaryGreen,
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                'Protein',
                '${stats.consumedProtein.toStringAsFixed(1)} / ${stats.targetProtein.toStringAsFixed(0)}',
                'g',
                AppTheme.proteinColor,
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                'Carbs',
                '${stats.consumedCarbs.toStringAsFixed(1)} / ${stats.targetCarbs.toStringAsFixed(0)}',
                'g',
                AppTheme.carbsColor,
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                'Fat',
                '${stats.consumedFat.toStringAsFixed(1)} / ${stats.targetFat.toStringAsFixed(0)}',
                'g',
                AppTheme.fatColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, String unit, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No meals for this day',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your nutrition!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    final today = DateTime.now();
    if (_selectedDate.isBefore(today)) {
      setState(() {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
