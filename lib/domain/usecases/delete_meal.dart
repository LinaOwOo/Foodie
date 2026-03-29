import '../repositories/nutrition_repository.dart';

class DeleteMeal {
  final NutritionRepository repository;

  DeleteMeal(this.repository);

  Future<void> call(String mealId) async {
    await repository.deleteMeal(mealId);
  }
}
