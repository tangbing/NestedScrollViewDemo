

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

class DebounceButtonExample extends StatefulWidget {
  const DebounceButtonExample({super.key});

  @override
  State<DebounceButtonExample> createState() => _DebounceButtonExampleState();
}

class _DebounceButtonExampleState extends State<DebounceButtonExample> {
  bool _isLoading = false; //// 是否正在获取验证码
  final _debounceDuration = const Duration(seconds: 5);// 防抖时间 5 秒
  final _debounceController = StreamController<void>();

  @override
  void initState() {
    super.initState();
    _debounceController.stream.debounce(_debounceDuration).listen((_) {

      print('listen ed');

      _sendVerificationCode();
    },);
  }

  @override
  void dispose() {
    _debounceController.close();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    setState(() => _isLoading = true);
    // await Future.delayed(const Duration(seconds: 2));
    print('send verification code：4488');
    _startCountDown();
  }

  int _countDown = 60;

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDown == 1) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _countDown--;
          _isLoading = true;

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('防抖倒计时 demo'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
           if (!_isLoading) {
             _debounceController.add(null);// 将点击事件加入流
           }
        }, child: _isLoading ? Text('倒计时: ${_countDown}s') : const Text('获取验证码')),
      ),
    );
  }
}
