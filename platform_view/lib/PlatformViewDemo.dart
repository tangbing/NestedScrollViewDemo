

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformViewDemo extends StatefulWidget {
  const PlatformViewDemo({super.key});

  @override
  State<PlatformViewDemo> createState() => _PlatformViewDemoState();
}

class _PlatformViewDemoState extends State<PlatformViewDemo> {
  // Flutter 向 Android View 发送消息,创建 「MethodChannel」 用于通信
  static const platform = const MethodChannel('com.flutter.guide.MyFlutterView');
  var _data = '获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlatformViewDemo'),
      ),
      body: Column(
        children: [

          ElevatedButton(onPressed: () {
              platform.invokeMethod('setText', {'name' : 'tb', 'age' : 18});
          }, child: Text('传递参数给原生View')),

          ElevatedButton(onPressed: () async {
            var result = await platform.invokeMethod('getData', {'name' : 'tb', 'age' : 18});
            String name = result['name'] as String;
            int age = (result['age'] as num).toInt();
            setState(() {
              _data = 'receive android to flutter data： name: $name, age: $age';
            });
          }, child: Text(_data)),
          Expanded(child: platformView()),

        ],
      ),
    );
  }

  Widget platformView() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.flutter.io/custom_platform_view',
        creationParams: {'text' : 'Flutter传给AndroidTextView的参数'},
        creationParamsCodec: StandardMessageCodec(),
      );
    }
    return Text('暂无 platform view');
  }
}
