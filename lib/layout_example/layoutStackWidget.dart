

import 'package:flutter/material.dart';

class LayoutStackWidget extends StatelessWidget {
  const LayoutStackWidget({super.key});

  // stack 没有位置的 stack的大小，是其中没有位置的最大的一个
  // passthrough 会把上一级的约束传递到下面，stack 始终以最大的 chidren，显示大小
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout-4 Stack层叠组件'),
      ),
      body: Center(
        child: Container(
          color: Colors.orange[200],
          child: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment(-1, 0.75),
            children: [
              // Positioned(
              //    right: 0,
              //     top: 0,
              //     child: FlutterLogo(size: 350)),

              FlutterLogo(size: 230),

              Text('Text', style: TextStyle(fontSize: 70)),

              Positioned(
                top: 0,
                left: 10,
                width: 1280,
                //right: 10,
                height: 80,
                child: Transform.translate(
                  offset: Offset(-50, 0),
                  child: Container(
                    color: Colors.green,
                    child: ElevatedButton(
                      child: Text("1111"),
                      onPressed: () {
                        print('aaaaaa');
                      },
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 270,
                  height: 24,
                  color: Colors.yellow,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
