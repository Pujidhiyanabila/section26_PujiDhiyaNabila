import 'package:section26/model/api/foods_api.dart';
import 'package:section26/model/foods_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'foods_api_test.mocks.dart';

@GenerateMocks([FoodAPI])
void main() {
  group('FoodAPI', (){
    FoodAPI foodAPI = MockFoodAPI();
    test('get all foods returns data', () async{
      when(foodAPI.getFoods()).thenAnswer(
        (_) async => <Food>[
          Food(id: 1, name: 'b'),
        ],
      );
      var foods = await FoodAPI().getFoods();
      expect(foods?.isNotEmpty, true);
    });
  });
}