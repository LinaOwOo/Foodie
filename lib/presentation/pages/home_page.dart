import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/circular_progress_card.dart';
import '../widgets/macro_progress_bar.dart';
import '../widgets/meal_card.dart';
import 'add_meal_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dailyStatsProvider);
    final meals = ref.watch(mealsProvider);
    final mealsNotifier = ref.read(mealsProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Foodie'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => mealsNotifier.loadTodayMeals(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircularProgressCard(
                percentage: stats.calorieProgress,
                currentValue: stats.consumedCalories,
                targetValue: stats.targetCalories,
                label: 'Daily intake',
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              const Text(
                'Nutrition',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              MacroProgressBar(
                label: 'Protein',
                current: stats.consumedProtein,
                target: stats.targetProtein,
                percentage: stats.proteinProgress,
                color: AppTheme.proteinColor,
                icon: Icons.fitness_center,
              ),
              MacroProgressBar(
                label: 'Carbs',
                current: stats.consumedCarbs,
                target: stats.targetCarbs,
                percentage: stats.carbsProgress,
                color: AppTheme.carbsColor,
                icon: Icons.grain,
              ),
              MacroProgressBar(
                label: 'Fat',
                current: stats.consumedFat,
                target: stats.targetFat,
                percentage: stats.fatProgress,
                color: AppTheme.fatColor,
                icon: Icons.water_drop,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently logged',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See all')),
                ],
              ),
              const SizedBox(height: 12),
              if (meals.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No meals logged today',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return MealCard(
                      meal: meal,
                      onDelete: () => mealsNotifier.deleteMeal(meal.id),
                    );
                  },
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMealPage()),
          );
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}
