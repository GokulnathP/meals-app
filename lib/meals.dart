import 'package:flutter/material.dart';

import 'widgets/meal_item.dart';

import 'models/meals.dart';

class Meals extends StatefulWidget {
  static const routeName = '/meals';

  final List<Meal> availableMeals;

  Meals(this.availableMeals);

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  String title;
  List<Meal> meals;
  var _loadedMeal = false;

  @override
  void didChangeDependencies() {
    if (!_loadedMeal) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final id = routeArgs['id'];
      title = routeArgs['title'];
      meals = widget.availableMeals.where((meal) {
        return meal.categories.contains(id);
      }).toList();
      _loadedMeal = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: meals[index].id,
            title: meals[index].title,
            imageUrl: meals[index].imageUrl,
            duration: meals[index].duration,
            complexity: meals[index].complexity,
            affordability: meals[index].affordability,
          );
        },
        itemCount: meals.length,
      ),
    );
  }
}
