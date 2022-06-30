import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section26/provider/foods_view_model.dart';
import 'package:section26/screen/food_screen.dart';
import 'package:section26/screen/foodadd_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => FoodViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

PageRouteBuilder routeBuilder(
  Widget widget,
  RouteSettings routeSettings,
) {
  return PageRouteBuilder(
    settings: routeSettings,
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (set) {
        switch (set.name) {
          case FoodAdd.route:
            return routeBuilder(FoodAdd(), set);
          default:
            return routeBuilder(const FoodScreen(), set);
        }
      },
    );
  }
}