import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/meal.dart';
import '../providers/nutrition_provider.dart';

class AddMealPage extends ConsumerStatefulWidget {
  const AddMealPage({super.key});

  @override
  ConsumerState<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends ConsumerState<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    if (_formKey.currentState!.validate()) {
      final meal = Meal(
        id: const Uuid().v4(),
        name: _nameController.text,
        calories: double.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbs: double.parse(_carbsController.text),
        fat: double.parse(_fatController.text),
        timestamp: DateTime.now(),
      );

      final notifier = ref.read(mealsProvider.notifier);
      await notifier.addMeal(meal);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Meal'),
        actions: [
          TextButton(
            onPressed: _saveMeal,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Add Photo',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Meal Name',
                hint: 'e.g., Chicken Salad',
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _caloriesController,
                label: 'Calories',
                hint: '0',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Macronutrients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _proteinController,
                label: 'Protein (g)',
                hint: '0',
                icon: Icons.fitness_center,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _carbsController,
                label: 'Carbs (g)',
                hint: '0',
                icon: Icons.grain,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _fatController,
                label: 'Fat (g)',
                hint: '0',
                icon: Icons.water_drop,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
