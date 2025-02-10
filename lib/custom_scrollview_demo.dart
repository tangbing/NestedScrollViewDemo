


import 'package:flutter/material.dart';

class CustomScrollviewWidget extends StatelessWidget {
  const CustomScrollviewWidget({super.key});
  static const title = 'Floating App Bar';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('CustomScrollView Demo'),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('CustomScrollView Demo'),
            floating: true,
            // 控制 SliverAppBar 是否固定在顶部，即滚动到顶部后是否保持可见
            pinned: true,
            // snap: true,
            flexibleSpace: Image.asset('assets/images/profile/dhuhr_pic_bg01.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
            expandedHeight: 200,
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: 1000,
                  (context, index) {
             return ListTile(title: Text('Item #$index'));
          }),
          )
        ],
      ),
    );

  }
}
