

import 'package:first_project/customPaint/CustomCheckbox.dart';
import 'package:flutter/material.dart';

class CustomCheckboxTest extends StatefulWidget {
  const CustomCheckboxTest({super.key});

  @override
  State<CustomCheckboxTest> createState() => _CustomCheckboxTestState();
}

class _CustomCheckboxTestState extends State<CustomCheckboxTest> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomCheckbox Demo'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCheckbox(
                value: _checked,
                onChanged: _onChange),
            Padding(padding: EdgeInsets.all(18),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CustomCheckbox(
                  strokeWidth: 1,
                    radius: 1,
                    value: _checked,
                    onChanged: _onChange),
              ),
            ),
            
            SizedBox(
              width: 30,
              height: 30,
              child: CustomCheckbox(
                strokeWidth: 3,
                  radius: 3,
                  value: _checked,
                  onChanged: _onChange),
            ),
            
          ],
        ),
      ),
    );
  }

  void _onChange(value) {
    setState(() => _checked = value);
  }
}
