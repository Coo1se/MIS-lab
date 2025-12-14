class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
    );
  }
}

class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String? strYoutube;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    this.strYoutube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ingredient.toString().trim(),
            measure: measure?.toString().trim() ?? '',
          ),
        );
      }
    }

    return MealDetail(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strArea: json['strArea'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}

class Ingredient {
  final String name;
  final String measure;

  Ingredient({
    required this.name,
    required this.measure,
  });
}
