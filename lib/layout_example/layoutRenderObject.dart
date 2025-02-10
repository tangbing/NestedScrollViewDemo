

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyRenderBoxWidget extends StatelessWidget {
  const MyRenderBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自己动手写个RenderObject'),
      ),
      body: Container(
        color: Colors.red[200],
        child: ShadowBox(
          child: FlutterLogo(size: 250.0),
          distance: 10,
        ),
      ),
    );
  }
}

class ShadowBox extends SingleChildRenderObjectWidget {
   final double distance;

  ShadowBox({required Widget child, required this.distance}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
     return RenderShapeRenderBox(distance);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderShapeRenderBox renderObject) {
     renderObject.distance = distance;
  }
}

class RenderShapeRenderBox extends RenderProxyBox with DebugOverflowIndicatorMixin {

  double distance;

  RenderShapeRenderBox(this.distance);

  // @override
  // void performLayout() {
  //   child?.layout(constraints, parentUsesSize: true);
  //   size = (child as RenderBox).size;
  // }
  //


  @override
  void paint(PaintingContext context, Offset offset) {
    print(offset);
    context.paintChild(child!, offset);

    context.pushOpacity(offset, 127, (context, offset) {
       context.paintChild(child!,  offset + Offset(distance ,distance));
    });
    
    paintOverflowIndicator(context, offset,
        Offset.zero & size,
        // Rect.fromLTWH(0, 0, size.width, size.height),
        Rect.fromLTWH(0, 0, 320, 300));
    
  }



}
