

import 'package:flutter/material.dart';

class KeyExampleWidget extends StatefulWidget {
  const KeyExampleWidget({super.key});

  @override
  State<KeyExampleWidget> createState() => _KeyExampleWidgetState();
}

class _KeyExampleWidgetState extends State<KeyExampleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('没有可以会发生什么奇怪现象'),
      ),
      body: Center(
        child: Column(
          children: [
            Box(bgColor: Colors.red, key: Key("2")),
            Box(bgColor: Colors.orange, key: Key("3")),
            Box(bgColor: Colors.yellow, key: Key("1")),

          ],
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  const Box({super.key, required this.bgColor});

  final Color bgColor;
  

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _counter ++;
        });
      },
      child: Container(
        alignment: Alignment.center,
        color: widget.bgColor,
        width: 200,
        height: 200,
        child: Text('$_counter', style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
