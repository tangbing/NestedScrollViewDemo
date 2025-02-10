

import 'package:flutter/material.dart';

class LayoutThreeWidget extends StatelessWidget {
  const LayoutThreeWidget({super.key});


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Layout-3 Flex弹性布局'),
        ),
        body: Center(
          child: Container(
            color: Colors.green[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlutterLogo(size: 50),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      print('constraints: $constraints');
                      return ListView(
                        children: [
                          for (int i = 0; i < 100; i++)
                            Text('ListView item $i')
                        ],
                      );
                    },
                  ),
                ),
                FlutterLogo(size: 80),

              ],
            ),
          ),
        ),
      );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Layout-3 Flex弹性布局'),
  //     ),
  //     body: Container(
  //       color: Colors.green[200],
  //       constraints: BoxConstraints(
  //         maxHeight: 700,
  //         maxWidth: 500,
  //         minHeight: 50,
  //         minWidth: 300
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           ElevatedButton(onPressed: () {}, child: Text("11")),
  //           ElevatedButton(onPressed: () {}, child: Text("22")),
  //           Expanded(
  //             child: Container(
  //               width: 20,
  //               height: 20,
  //               color: Colors.red,
  //             ),
  //           ),
  //           FlutterLogo(size: 100),
  //           FlutterLogo(size: 28),
  //           FlutterLogo(size: 50),
  //           Expanded(
  //             child: Container(
  //               width: 20,
  //               height: 20,
  //               color: Colors.red,
  //             ),
  //           ),
  //           FlutterLogo(size: 50),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
