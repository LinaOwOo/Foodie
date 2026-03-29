import '../entities/meal.dart';

abstract class NutritionRepository {
  Future<List<Meal>> getTodayMeals();
  Future<void> addMeal(Meal meal);
  Future<void> deleteMeal(String id);
  Future<List<Meal>> getMealsByDate(DateTime date);
}
