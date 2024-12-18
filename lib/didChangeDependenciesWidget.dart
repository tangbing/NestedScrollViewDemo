
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterProvider extends InheritedWidget {
  final int counter;

  const CounterProvider({
    Key? key,
    required this.counter,
    required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    // 当counter 值发生变化时通知依赖组件
    return oldWidget.counter != counter;
  }

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }
}

// 子组件响应 CounterProvider 的变化
class CounterConsumer extends StatefulWidget {
  const CounterConsumer({super.key});

  @override
  State<CounterConsumer> createState() => _CounterConsumerState();
}

class _CounterConsumerState extends State<CounterConsumer> {
  int? _counter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = CounterProvider.of(context);
    setState(() {
      _counter = provider?.counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CounterProvider(
        counter: _counter,
        child: Scaffold(
          appBar: AppBar(
            title: Text('didChangeDependencies 示例'),
          ),
          body: Center(child: CounterConsumer()),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: _incrementCounter),
        )
    );
  }
}

