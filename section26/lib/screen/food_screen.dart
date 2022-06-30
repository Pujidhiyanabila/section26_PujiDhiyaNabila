import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section26/provider/foods_view_model.dart';
import 'package:section26/screen/foodadd_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);
  static const String route = '/food';

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  bool add = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (add) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) async {
          Future viewModel =
              Provider.of<FoodViewModel>(context, listen: false).getAllFoods();
          await viewModel;
        },
      );
      add = false;
    }
  }

  Widget stateBody(FoodViewModel viewModel) {
    final isLoading = viewModel.state == FoodViewState.loading;
    final isError = viewModel.state == FoodViewState.error;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (isError) {
      return const Center(
        child: Text('Error'),
      );
    }
    return listView(viewModel);
  }

  Widget listView(FoodViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.foods.length,
      itemBuilder: (context, index) {
        final food = viewModel.foods[index];
        return InkWell(
          onTap: () async {
            final argument = {
              'contact': viewModel.foods[index],
              'index': viewModel.foods.indexOf(viewModel.foods[index]),
            };
            final ReturnParam result = await Navigator.pushNamed(
              context,
              FoodAdd.route,
              arguments: argument,
            ) as ReturnParam;
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text('Food updated'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: result.color,
                ),
              );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                food.name!.substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(food.name!),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to delete this foods?'),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).splashColor,
                            ),
                          ),
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).errorColor,
                            ),
                          ),
                          child: const Text('Delete'),
                          onPressed: () {
                            viewModel.removeFood(food);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food'),
      ),
      body: Column(
        children: [
          Expanded(
            child: stateBody(foodProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ReturnParam result = await Navigator.pushNamed(
            context,
            FoodAdd.route,
          ) as ReturnParam;

          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text('Foods added'),
                duration: const Duration(seconds: 1),
                backgroundColor: result.color,
              ),
            );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
