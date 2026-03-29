import '../entities/meal.dart';
import '../repositories/nutrition_repository.dart';

class AddMeal {
  final NutritionRepository repository;

  AddMeal(this.repository);

  Future<void> call(Meal meal) async {
    await repository.addMeal(meal);
  }
}
