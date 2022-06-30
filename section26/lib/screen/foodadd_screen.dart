import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section26/model/foods_model.dart';
import 'package:section26/provider/foods_view_model.dart';

class FoodAdd extends StatelessWidget {
  FoodAdd({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  static const String route = '/foodadd';

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodViewModel>(context, listen: false);
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    Food? food = arguments?['food'] as Food?;
    int? index = arguments?['index'] as int?;
    foodProvider.nameController.text = food?.name ?? '';

    bool isEdit = foodProvider.nameController.text.isNotEmpty;
    Food initEdit = Food(
      id: food?.id ?? 0,
      name: foodProvider.nameController.text,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEdit == true ? 'Edit' : 'Add'} Food'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: foodProvider.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: Text('${isEdit == true ? 'Edit' : 'Add'} Contact'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isEdit) {
                      foodProvider.editFood(
                        Food(
                          id: index!,
                          name: foodProvider.nameController.text,
                        ),
                        initEdit,
                      );
                      Navigator.pop(context);
                    } else {
                      foodProvider.addFood(
                        Food(
                          id: foodProvider.foods.length,
                          name: foodProvider.nameController.text,
                        ),
                      );
                      Navigator.pop(
                          context, ReturnParam(food, index, Colors.green));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReturnParam {
  final Food? contact;
  final int? index;
  final Color? color;
  ReturnParam(this.contact, this.index, this.color);
}
