

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MySliverPage extends StatefulWidget {
  const MySliverPage({super.key});

  @override
  State<MySliverPage> createState() => _MySliverPageState();
}

class _MySliverPageState extends State<MySliverPage> {
  
  final ScrollController _controller = ScrollController();
  bool showAppBar = false;
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }
  
  void _onScroll() {
    final offset = _controller.offset;
    
    if (offset > 100 && !showAppBar) {
      setState(() {
        showAppBar = true;
      });
    } else if (offset <= 100 && showAppBar) {
      setState(() {
        showAppBar = false;
      });
    }
    
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }
  
  
  Widget _buildHeaderBar() {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Row(children: [
          SizedBox(width: 15.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: 30.w,
              height: 30.w,
              child: CachedNetworkImage(
                imageUrl: 'https://img2.baidu.com/it/u=3901868821,1751410039&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Text("lynxx", style: TextStyle(fontSize: 12.sp, color: Colors.black)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.black, size: 15))

        ]),
      ],
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverLayoutBuilder(builder: (context, constraints) {
              return SliverAppBar(
                pinned: true,
                backgroundColor:  showAppBar ? Colors.white : Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                toolbarHeight: showAppBar ? 54 : 0,
                flexibleSpace: showAppBar ? FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _buildHeaderBar(),
                ) : null,
              );
          }),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) => ListTile(title: Text("item: ${index}")),
                childCount: 130,
              )
          )
        ],
      ),
    );
  }
}
