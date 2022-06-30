import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:section26/model/api/foods_api.dart';
import 'package:section26/model/foods_model.dart';

enum FoodViewState {
  loading,
  loaded,
  error,
}

class FoodViewModel with ChangeNotifier {
  FoodViewState _state = FoodViewState.loaded;
  FoodViewState get state => _state;

  changeState(FoodViewState state) {
    _state = state;
    notifyListeners();
  }

  final List<Food> _foods = [];

  List<Food> get foods => _foods;

  var nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void addFood(Food food) {
    _foods.add(food);
    notifyListeners();
  }

  void editFood(Food foodEdit, Food initEdit) {
    Food food = _foods.firstWhere(
      (food) => food.id == initEdit.id && food.name == initEdit.name,
    );
    food.name = foodEdit.name;
    notifyListeners();
  }

  void removeFood(Food food) {
    _foods.remove(food);
    notifyListeners();
  }

  void updateFood(Food food) {
    notifyListeners();
  }

  bool ulang = true;
  getAllFoods() async {
    changeState(FoodViewState.loading);
    try {
      final foods = await FoodAPI().getFoods();
      if (ulang) {
        foods?.forEach((element) {
          bool listContains = _foods.contains(element);
          if (!listContains) {
            _foods.add(element);
          }
        });
        ulang = false;
      }
      notifyListeners();
      changeState(FoodViewState.loaded);
    } catch (e) {
      changeState(FoodViewState.error);
    }
  }

  addJsonToFood(List<String> listStringFood) async {
    for (var element in listStringFood) {
      // print(element);
      Map<String, dynamic> json = jsonDecode(element);
      if (kDebugMode) {
        print(json);
      }
      Food food = Food(
        id: json['id'],
        name: json['name'],
      );
      bool cContaints = _foods.contains(food);
      if (!cContaints) {
        _foods.add(food);
      }
    }
  }

  List<String> getToJson() {
    List<String> list = [];
    for (var element in _foods) {
      list.add(jsonEncode(element));
    }
    return list;
  }
}