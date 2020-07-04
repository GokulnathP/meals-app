import 'package:flutter/material.dart';

import 'models/meals.dart';
import 'dummy_data.dart';

import 'tabs.dart';
import 'meals.dart';
import 'filters.dart';
import 'meals_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filter = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilter(Map<String, bool> filterData) {
    setState(() {
      _filter = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filter['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filter['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filter['vegan'] && !meal.isVegan) {
          return false;
        }
        if (_filter['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final index = _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (index >= 0) {
      setState(() {
        _favoriteMeals.removeAt(index);
      });
    } else {
      setState(() {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isFavorite(String mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => Tabs(_favoriteMeals),
        Meals.routeName: (ctx) => Meals(_availableMeals),
        MealsDetails.routeName: (ctx) =>
            MealsDetails(_toggleFavorite, _isFavorite),
        Filters.routeName: (ctx) => Filters(_filter, _setFilter),
      },
      // onGenerateRoute: (settings){
      //   print(settings.arguments);
      //   if(settings.name == '/meal-detail'){
      //     return MaterialPageRoute(builder: (ctx) => Categories());
      //   }else if(settings.name == '/something-else'){
      //     return MaterialPageRoute(builder: (ctx) => Categories());
      //   }
      //   return MaterialPageRoute(builder: (ctx) => Categories());
      // },
      // onUnknownRoute: (settings){
      //   return MaterialPageRoute(builder: (ctx) => Categories()); // 404 error
      // },
    );
  }
}
