

import 'package:flutter/material.dart';



class TbAnimationedContainer extends StatefulWidget {
  const TbAnimationedContainer({super.key});

  @override
  State<TbAnimationedContainer> createState() => _TbAnimationedContainerState();
}

class _TbAnimationedContainerState extends State<TbAnimationedContainer> {

  bool _expanded = false;

  /*
  隐式动画：只告诉 Flutter“最终变成什么样”，Flutter自动完成动画。
  一、隐式动画
适合简单的尺寸、颜色、位置、透明度变化。
常用组件：
AnimatedContainer
AnimatedOpacity
AnimatedAlign
AnimatedPadding
AnimatedPositioned
AnimatedSwitcher
TweenAnimationBuilder

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('隐式动画'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      onPressed: () => setState(() {
         _expanded = !_expanded;
      })),
      body: Center(
        child: IgnorePointer(// opacity: 0 只是看不见，组件仍然可能接收点击。需要同时禁止点击时
           ignoring: !_expanded,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            opacity: _expanded ? 1: 0,
            child: Text('内容'),
          ),
        ),
      ),
    );
  }
}
