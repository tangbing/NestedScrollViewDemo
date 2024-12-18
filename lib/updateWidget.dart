

import 'package:flutter/material.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
    print('incrementCount: $_count');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('widget didUpdate触发时机'),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _incrementCounter, child: Text('Increment Counter')),
            ChildWidget(counter: _count),
          ],
        ),
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({super.key, required this.counter});
  final int counter;

  @override
  State<ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  late int _displayCounter;

  @override
  void initState() {
    super.initState();
    _displayCounter = widget.counter;
    print('initState: $_displayCounter');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('didChangeDependencies: $_displayCounter');
  }

  /*
  父组件向子组件传递 counter 值，
  子组件根据 didUpdateWidget() 检测到父组件的值变化后更新内部显示
   */
  @override
  void didUpdateWidget(covariant ChildWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget: $_displayCounter, oldWidget.counter: ${oldWidget.counter}');
    print('didUpdateWidget: ${widget.counter}');
    if (oldWidget.counter != widget.counter) {
      setState(() {
        _displayCounter = widget.counter;
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    print('build: $_displayCounter');
    return Text('Counter: $_displayCounter');
  }
}

