import '../../domain/entities/meal.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/local_storage.dart';
import '../models/meal_model.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  final LocalStorage localStorage;

  NutritionRepositoryImpl(this.localStorage);

  @override
  Future<List<Meal>> getTodayMeals() async {
    final meals = await localStorage.getMeals();
    final today = DateTime.now();

    return meals.where((meal) {
      return meal.timestamp.year == today.year &&
          meal.timestamp.month == today.month &&
          meal.timestamp.day == today.day;
    }).toList();
  }

  @override
  Future<void> addMeal(Meal meal) async {
    final meals = await localStorage.getMeals();
    meals.add(
      MealModel(
        id: meal.id,
        name: meal.name,
        calories: meal.calories,
        protein: meal.protein,
        carbs: meal.carbs,
        fat: meal.fat,
        timestamp: meal.timestamp,
        imageUrl: meal.imageUrl,
      ),
    );
    await localStorage.saveMeals(meals);
  }

  @override
  Future<void> deleteMeal(String id) async {
    final meals = await localStorage.getMeals();
    meals.removeWhere((meal) => meal.id == id);
    await localStorage.saveMeals(meals);
  }

  @override
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final meals = await localStorage.getMeals();
    return meals.where((meal) {
      return meal.timestamp.year == date.year &&
          meal.timestamp.month == date.month &&
          meal.timestamp.day == date.day;
    }).toList();
  }
}
