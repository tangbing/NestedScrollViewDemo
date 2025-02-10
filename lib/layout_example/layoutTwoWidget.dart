

import 'package:flutter/material.dart';

class LayoutTwoWidget extends StatelessWidget {
  const LayoutTwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Layout-2 获取和设置布局约束'),
      ),
      body: Container(
        width: 400,
        height: 400,
        color: Colors.red[200],
        child: Center(
          child: ConstrainedBox(
           // constraints: BoxConstraints.tightFor(width: 120, height: 120),
            constraints: BoxConstraints(
              minWidth: 60,
              maxWidth: double.infinity,
              minHeight: 60,
              maxHeight: double.infinity,
            ).loosen(), // loosen 变成松约束 BoxConstraints(0.0<=w<=400.0, 0.0<=h<=400.0)
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                print("constraints: ${constraints}");
                 return FlutterLogo(size: 11240);
              },
            ),
          ),
        ),
      ),
    );
  }
}
