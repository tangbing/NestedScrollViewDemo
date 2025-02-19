


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SdcardDemo extends StatelessWidget {
  const SdcardDemo({super.key});

  static const platform = MethodChannel('com.exmaple.scard');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SD card path')),
      body: Center(
        child: ElevatedButton(onPressed: () {
          _getSdCardPath();

        }, child: Text('Get SD Card Path')),
      ),
    );
  }

  Future<void> getAppDirectory() async {
    final directory = await getExternalStorageDirectory();// 获取外部存储目录
    print('App directory: ${directory?.path}');
  }

  Future<void> _getSdCardPath() async {
    try {
         final String sdCardPath = await platform.invokeMethod('getSdCardPath');
         print('SD Card Path: $sdCardPath');
    } on PlatformException catch (e) {
      print('Failed to get SD card Path: ${e.message}');
    }
  }
}
