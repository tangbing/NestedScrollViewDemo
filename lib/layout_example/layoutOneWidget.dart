
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutOneWidget extends StatelessWidget {
  const LayoutOneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout-1 约束、尺寸、位置'),
      ),
      body: Container(
        width: 400,
        height: 400,
        color: Colors.black,
        child: Container(
          width: 300,
          height: 300,
          color: Colors.orange,
          child: FlutterLogo(
              size: 100
          ),
        ),
      ),
    );
  }
}
