
import 'package:flutter/material.dart';

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('高度可变的输入框'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 44,
                decoration: BoxDecoration(
                    color: const Color(0xFFDCEDFF),
                  borderRadius: BorderRadius.circular(4)
                ),
                child: const TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                      ),
                      prefixIconConstraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40
                      ),
                      // border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          )),

      );
  }
}
