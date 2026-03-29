import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/meal_model.dart';

class LocalStorage {
  Future<List<MealModel>> getMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(AppConstants.storageKey);

    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => MealModel.fromJson(json)).toList();
  }

  Future<void> saveMeals(List<MealModel> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = meals
        .map((meal) => meal.toJson())
        .toList();
    await prefs.setString(AppConstants.storageKey, json.encode(jsonList));
  }

  Future<void> clearTodayMeals() async {
    final meals = await getMeals();
    final today = DateTime.now();

    final remainingMeals = meals
        .where(
          (meal) =>
              meal.timestamp.year != today.year ||
              meal.timestamp.month != today.month ||
              meal.timestamp.day != today.day,
        )
        .toList();

    await saveMeals(remainingMeals);
  }
}
