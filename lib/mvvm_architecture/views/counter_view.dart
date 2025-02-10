
import 'package:first_project/mvvm_architecture/models/counter_model.dart';
import 'package:first_project/mvvm_architecture/viewModels/counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    CounterViewModel counterViewModel = Provider.of<CounterViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter mvvvm Architecture'),
      ),
      body: Center(
        child: Text('${counterViewModel.counterModel.counter}'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => counterViewModel.increment(),
          child: Icon(Icons.add),
      ),
    );
  }
}
