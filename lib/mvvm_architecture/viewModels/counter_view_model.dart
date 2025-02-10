

import 'package:first_project/mvvm_architecture/models/counter_model.dart';
import 'package:flutter/cupertino.dart';

class CounterViewModel with ChangeNotifier {

  final CounterModel _counterModel = CounterModel(counter: 0);

  CounterModel get counterModel => _counterModel;

  void increment() {
    _counterModel.counter ++;
    notifyListeners();
  }
}