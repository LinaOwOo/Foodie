import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_storage.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../domain/entities/meal.dart';
import '../../domain/entities/daily_stats.dart';
import '../../domain/usecases/add_meal.dart';
import '../../domain/usecases/delete_meal.dart';
import '../../domain/usecases/get_daily_stats.dart';

final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final repositoryProvider = Provider<NutritionRepositoryImpl>((ref) {
  return NutritionRepositoryImpl(ref.read(localStorageProvider));
});

final getDailyStatsProvider = Provider<GetDailyStats>((ref) => GetDailyStats());

final addMealProvider = Provider<AddMeal>((ref) {
  return AddMeal(ref.read(repositoryProvider));
});

final deleteMealProvider = Provider<DeleteMeal>((ref) {
  return DeleteMeal(ref.read(repositoryProvider));
});

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier(ref.read(repositoryProvider));
});

class MealsNotifier extends StateNotifier<List<Meal>> {
  final NutritionRepositoryImpl repository;

  MealsNotifier(this.repository) : super([]) {
    loadTodayMeals();
  }

  Future<void> loadTodayMeals() async {
    final meals = await repository.getTodayMeals();
    state = meals;
  }

  Future<void> addMeal(Meal meal) async {
    await repository.addMeal(meal);
    await loadTodayMeals();
  }

  Future<void> deleteMeal(String id) async {
    await repository.deleteMeal(id);
    await loadTodayMeals();
  }
}

final dailyStatsProvider = Provider<DailyStats>((ref) {
  final meals = ref.watch(mealsProvider);
  final getStats = ref.read(getDailyStatsProvider);
  return getStats(meals);
});
