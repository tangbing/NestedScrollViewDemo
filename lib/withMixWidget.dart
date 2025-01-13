

import 'dart:async';

import 'package:flutter/material.dart';

class Withmixwidget extends StatefulWidget {
  const Withmixwidget({super.key});

  @override
  State<Withmixwidget> createState() => _WithmixwidgetState();
}

class _WithmixwidgetState extends State<Withmixwidget> with RefreshData {

  @override
  void initState() {
    super.initState();

    print('Withmixwidget init');

    RefreshData.testData();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试一下混入'),
      ),
      body: Text('widget: $isAsync'),
    );
  }
}


mixin RefreshData<T extends StatefulWidget> on State<T> {
  bool initFlage = true;

  String isAsync = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  static void testData() {
    print('test data');
  }

  Future<void> initData() async {
    if (initFlage) {
      print('init success');
      var result = _showInitData(false);
      isAsync = await result;

    }
  }

  FutureOr<String> _showInitData(bool isAsync) {
    if (isAsync) {
      return Future.delayed(const Duration(milliseconds: 500), () => 'Async Data');
    } else {
     return 'Sync data';
    }
  }

}