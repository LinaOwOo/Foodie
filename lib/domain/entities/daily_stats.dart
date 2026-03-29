class DailyStats {
  final double consumedCalories;
  final double consumedProtein;
  final double consumedCarbs;
  final double consumedFat;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;

  DailyStats({
    required this.consumedCalories,
    required this.consumedProtein,
    required this.consumedCarbs,
    required this.consumedFat,
    this.targetCalories = 2000,
    this.targetProtein = 150,
    this.targetCarbs = 250,
    this.targetFat = 65,
  });

  double get calorieProgress =>
      ((consumedCalories / targetCalories) * 100).clamp(0, 100);

  double get proteinProgress =>
      ((consumedProtein / targetProtein) * 100).clamp(0, 100);

  double get carbsProgress =>
      ((consumedCarbs / targetCarbs) * 100).clamp(0, 100);

  double get fatProgress => ((consumedFat / targetFat) * 100).clamp(0, 100);

  double get remainingCalories => targetCalories - consumedCalories;
}
