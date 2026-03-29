import '../entities/daily_stats.dart';
import '../entities/meal.dart';

class GetDailyStats {
  DailyStats call(
    List<Meal> meals, {
    double targetCalories = 2000,
    double targetProtein = 150,
    double targetCarbs = 250,
    double targetFat = 65,
  }) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var meal in meals) {
      totalCalories += meal.calories;
      totalProtein += meal.protein;
      totalCarbs += meal.carbs;
      totalFat += meal.fat;
    }

    return DailyStats(
      consumedCalories: totalCalories,
      consumedProtein: totalProtein,
      consumedCarbs: totalCarbs,
      consumedFat: totalFat,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
    );
  }
}
