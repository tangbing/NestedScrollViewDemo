

import 'package:flutter/material.dart';

class Keydemowidget extends StatefulWidget {
  const Keydemowidget({super.key});

  @override
  State<Keydemowidget> createState() => _KeydemowidgetState();
}

class _KeydemowidgetState extends State<Keydemowidget> {
  List<Widget> widgets = [
    StatelessContainer(color: Colors.red),
    StatelessContainer(color: Colors.yellow)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.undo),
          onPressed: () {
        widgets.insert(0, widgets.removeAt(1));
        setState(() {});
      }),
    );
  }
}

class StatelessContainer extends StatefulWidget {
  const StatelessContainer({super.key, required this.color});
  final Color color;

  @override
  State<StatelessContainer> createState() => _StatelessContainerState();
}

class _StatelessContainerState extends State<StatelessContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: widget.color,
    );
  }
}
