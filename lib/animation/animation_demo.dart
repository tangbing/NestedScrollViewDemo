

import 'dart:math';

import 'package:flutter/material.dart';



class TbAnimationedAContainer extends StatefulWidget {
  const TbAnimationedAContainer({super.key});

  @override
  State<TbAnimationedAContainer> createState() => _TbAnimationedContainerState();
}

class _TbAnimationedContainerState extends State<TbAnimationedAContainer> with SingleTickerProviderStateMixin{

  bool _expanded = false;

  /*
  显示动画：自己控制开始、暂停、反向、重复和动画进度。
适合需要精确控制的动画，例如：
开始、停止
正向、反向
循环
多段动画
多个属性同步变化
手势控制动画进度
核心对象：
AnimationController：控制时间和进度
Tween：定义开始值和结束值
Curve：控制动画速度变化
Animation：提供当前动画值

   */

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
        vsync: this);
    
    
    final curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1
    ).animate(curvedAnimation);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curvedAnimation);

    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //传入 Animation 对象 → Transition 自己监听，不需要 AnimatedBuilder
  // 读取 animation.value → 需要 AnimatedBuilder 触发重建

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('现式动画'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => setState(() {
            _expanded = !_expanded;
            _expanded ? _controller.reverse() : _controller.forward();

          })),
      body: Center(
        child: FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: const Icon(
                              Icons.favorite,
                              size: 80,
                              color: Colors.red,
                            ),
            )
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('现式动画'),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //         child: const Icon(Icons.add),
  //         onPressed: () => setState(() {
  //           _expanded = !_expanded;
  //           _expanded ? _controller.reverse() : _controller.forward();
  //
  //         })),
  //     body: Center(
  //       child: FadeTransition(
  //         opacity: _controller,
  //         child: SlideTransition(
  //             position: Tween<Offset>(begin: Offset(0,0.2), end: Offset.zero).animate(_controller),
  //             child: const Icon(
  //               Icons.favorite,
  //               size: 80,
  //               color: Colors.red,
  //             ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
