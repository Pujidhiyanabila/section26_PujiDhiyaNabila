import 'package:dio/dio.dart';
import 'package:section26/model/foods_model.dart';

class FoodAPI {
  Future<List<Food>?> getFoods() async {
    try {
      final response = await Dio().get(
          "https://my-json-server.typicode.com/hadihammurabi/flutter-webservice/foods");
      List<Food> foods = (response.data as List)
          .map((food) => Food(
                id: food['id'],
                name: food['name'],
              ))
          .toList();
      return foods;
    } catch (e) {
      return null;
    }
  }
}
