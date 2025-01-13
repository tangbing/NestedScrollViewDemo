import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RenderCustomCheckbox.dart';

class CustomCheckbox extends LeafRenderObjectWidget {

  CustomCheckbox(
      {
        super.key,
        this.strokeWidth = 2.0,// “勾”的线条宽度
        this.strokeColor = Colors.white,// “勾”的线条颜色
        this.fillColor = Colors.blue,// 填充颜色
        this.value = false,//选中状态
        this.radius = 2.0,// 圆角
        required this.onChanged // 选中状态发生改变后的回调
      });

  final double strokeWidth;
  final Color strokeColor;
  final Color? fillColor;
  final bool value;
  final double radius;
  final ValueChanged<bool>? onChanged;


  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomCheckbox(
        strokeWidth,
        strokeColor,
        fillColor!,
        value,
        radius,
        onChanged
    );
    // return RenderCustomCheckbox(
    //   strokeWidth: strokeWidth,
    //   strokeColor: strokeColor,
    //   fillColor: fillColor!,
    //   value: value,
    //   radius: radius);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCustomCheckbox renderObject) {
    if (renderObject.value != value) {
      renderObject.animationStatus = value ? AnimationStatus.forward : AnimationStatus.reverse;
    }

    renderObject..strokeWidth = strokeWidth
    ..strokeColor = strokeColor
    ..fillColor = fillColor ?? Theme.of(context).primaryColor
    ..radius = radius
    ..value = value
    ..onChanged = onChanged;
  }

}