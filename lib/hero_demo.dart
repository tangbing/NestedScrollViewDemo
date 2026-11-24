

import 'package:flutter/material.dart';

class HeroAnimationWidget extends StatefulWidget {
  const HeroAnimationWidget({super.key});

  @override
  State<HeroAnimationWidget> createState() => _HeroAnimationWidgetState();
}

class _HeroAnimationWidgetState extends State<HeroAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hero animation')),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: Scaffold(
                          appBar: AppBar(
                            title: Text('原图'),
                          ),
                          body: HeroAnimationRouteB(),
                        ),
                      );
                },
                    ));
              },
              child: Hero(tag: 'avatar', child:
              ClipOval(
                child: Image.asset('assets/images/commons/pic_default_avatar.png', width: 50.0),
              )),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('点击头像'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroAnimationRouteB extends StatelessWidget {
  const HeroAnimationRouteB({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(tag: 'avatar',
          child: Image.asset('assets/images/commons/pic_default_avatar.png')),
    );
  }
}

