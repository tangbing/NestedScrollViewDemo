


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class RenderCustomCheckbox extends RenderBox with RenderObjectAnimationMixin {

  bool value;
  int pointerId = -1;
  double strokeWidth;
  Color strokeColor;
  Color fillColor;
  double radius;
  ValueChanged<bool>? onChanged;


  RenderCustomCheckbox(this.strokeWidth, this.strokeColor, this.fillColor,
      this.value, this.radius, this.onChanged) {
    progress = value ? 1 : 0;
  }


//   RenderCustomCheckbox({
//     required this.strokeWidth,
//     required this.strokeColor,
//     required this.fillColor,
//     required this.value,
//     required this.radius,
//     this.onChanged
// }) : progress = value ? 1 : 0;

  @override
  // TODO: implement isRepaintBoundary
  bool get isRepaintBoundary => true;

  //背景动画时长占比（背景动画要在前40%的时间内执行完毕，之后执行打勾动画）
  final double bgAnimationInterval = .4;


  @override
  void performLayout() {
    // super.performLayout();
    // 如果父组件指定了固定宽高，则使用父组件指定的，否则宽高默认置为 25
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : const Size(25, 25)
    );
  }

  // 必须置为true，否则不可以响应事件
  @override
  bool hitTestSelf(Offset position) => true;

  // 只有通过点击测试的组件才会调用本方法
  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event.down) {
      pointerId = event.pointer;
    } else if (pointerId == event.pointer) {
      // 判断手指抬起时是在组件范围内的话才触发onChange
      if (size.contains(event.localPosition)) {
        onChanged?.call(!value);
      }
    }
  }
  
  // @override
  // void paint(PaintingContext context, Offset offset) {
  //       Rect rect = offset & size;
  //       // 将绘制分为背景（矩形）和 前景（打勾）两部分，先画背景，再绘制'勾'
  //       _drawBackground(context, rect);
  //       _drawCheckMark(context, rect);
  //       // 调度动画
  //       _scheduleAnimation();
  // }

  // 画背景
  void _drawBackground(PaintingContext context, Rect rect) {
    Color color = value ? fillColor : Colors.grey;
    var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeWidth = strokeWidth
    ..color = color;

    final outer = RRect.fromRectXY(rect, radius, radius);
    var rects = [
      rect.inflate(-strokeWidth),
      Rect.fromCenter(center: rect.center, width: 0, height: 0)
    ];

    var rectProcess = Rect.lerp(
        rects[0],
        rects[1],
        min(progress, bgAnimationInterval ) / bgAnimationInterval,
    )!;

    final inner = RRect.fromRectXY(rectProcess, 0, 0);

    context.canvas.drawDRRect(outer, inner, paint);


  }

  //画 "勾"
  void _drawCheckMark(PaintingContext context, Rect rect) {
    // 在画好背景后再画前景
    if (progress > bgAnimationInterval) {

      // 确定中间拐点位置
      final secondOffset = Offset(rect.left + rect.width / 2.5, rect.bottom - rect.height /4);

      // 第三个点的位置
      final _lastOffset = Offset(rect.right - rect.width / 6, rect.top + rect.height / 4);

      // 将三个点连接起来
      final path = Path()
      ..moveTo(rect.left + rect.width / 7, rect.top + rect.height / 2)
      ..lineTo(secondOffset.dx, secondOffset.dy)
      ..lineTo(_lastOffset.dx, _lastOffset.dy);

      final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = strokeColor
      ..strokeWidth = strokeWidth;

      context.canvas.drawPath(path, paint..style = PaintingStyle.stroke);

    }
  }

  @override
  void doPaint(PaintingContext context, Offset offset) {
     Rect rect = offset & size;
     _drawBackground(context, rect);
     _drawCheckMark(context, rect);
  }

}


mixin RenderObjectAnimationMixin on RenderObject {
  // 下面的属性用于调度动画
  double _progress = 0;  // 动画当前进度
  int? _lastTimeStamp; //上一次绘制的时间

  Duration get duration => const Duration(milliseconds: 150);

  AnimationStatus _animationStatus = AnimationStatus.completed;


  set animationStatus(AnimationStatus v) {
    if (_animationStatus != v) {
      markNeedsPaint();
    }
    _animationStatus = v;
  }

  double get progress => _progress;
  set progress(double v) {
    _progress = v.clamp(0, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
      doPaint(context, offset); // 调用子类绘制逻辑
      _scheduleAnimation();
  }


  void _scheduleAnimation() {
    if (_animationStatus != AnimationStatus.completed) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (_lastTimeStamp != null) {
            double delta = (timeStamp.inMilliseconds - _lastTimeStamp!) / duration.inMilliseconds;

          //在特定情况下，可能在一帧中连续的往frameCallback中添加了多次，导致两次回调时间间隔为0，
          //这种情况下应该继续请求重绘。
          if (delta == 0) {
            markNeedsPaint();
            return;
          }

          if (_animationStatus == AnimationStatus.reverse) {
            delta = -delta;
          }

          _progress = _progress + delta;
          if (_progress >= 1 || _progress <= 0) {
            _animationStatus = AnimationStatus.completed;
            _progress = _progress.clamp(0, 1);
          }
        }
        markNeedsPaint();
        _lastTimeStamp = timeStamp.inMilliseconds;

      });
    } else {
      _lastTimeStamp = null;
    }
  }

  // 子类实现绘制逻辑的地方
  void doPaint(PaintingContext context, Offset offset);
}