


import 'package:first_project/PopUtilWidget.dart';
import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});


  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin  {


  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this
    );
    
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    animation = Tween(begin: 0.0, end: 300.0).animate(animation)..addListener(() => setState(() {

    }));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation 动画Demo'),
        actions: [
          TextButton(onPressed: () {
               PopUtils.popLoginPage(context);
          }, child: Text('pop second page'))
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          width: animation.value,
          height: animation.value,
        ),
      ),
    );
  }
}
