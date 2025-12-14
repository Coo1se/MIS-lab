import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories.php'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final categories = (jsonData['categories'] as List)
            .map((c) => Category.fromJson(c))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['meals'] == null) return [];

        final meals = (jsonData['meals'] as List)
            .map((m) => Meal.fromJson(m))
            .toList();
        return meals;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['meals'] == null) return [];

        final meals = (jsonData['meals'] as List)
            .map((m) => Meal.fromJson(m))
            .toList();
        return meals;
      } else {
        throw Exception('Failed to search meals');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<MealDetail> fetchMealDetail(String mealId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$mealId'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['meals'] == null || jsonData['meals'].isEmpty) {
          throw Exception('No meal found');
        }

        final meal = MealDetail.fromJson(jsonData['meals'][0]);
        return meal;
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<MealDetail> fetchRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random.php'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['meals'] == null || jsonData['meals'].isEmpty) {
          throw Exception('No meal found');
        }

        final meal = MealDetail.fromJson(jsonData['meals'][0]);
        return meal;
      } else {
        throw Exception('Failed to load random meal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
