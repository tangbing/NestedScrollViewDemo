import 'package:first_project/profile_main_page.dart';
import 'package:first_project/tasbin_page.dart';
import 'package:flutter/material.dart';


class AppRouter {
  static String popUtil = '/popUtil';
  static String second = '/second';
  static String home = '/home';
  static String animation = '/animation';
}

class PopUtils {
  static List<String> loginRouter = [
    // 'second'
    AppRouter.home,
    AppRouter.animation
  ];

  static Future popLoginPage(context) async {
    print('cccc');
    Navigator.of(context).popUntil((route) {
      print('name: ${route.settings.name}');
      // return !loginRouter.contains(route.settings.name);
      return route.settings.name == AppRouter.second;
    });
  }
}

class PopUtilWidget extends StatelessWidget {
  const PopUtilWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('路由 popUtil Demo'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return SecondPage();
                    },
                    settings: RouteSettings(name: AppRouter.second)),
              );
            },
            child: Text('push to second')),
      ),
    );
  }
}

class HomPage extends StatefulWidget {
  const HomPage({super.key});

  @override
  State<HomPage> createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  int selectIdx = 0;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: PageView(
        controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TasbinPage(),
            ProfileMainPage(),
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectIdx,
          onTap: (value) {
            setState(() {
              selectIdx = value;
              pageController.animateToPage(selectIdx, duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'book',
                activeIcon: Icon(Icons.bookmark_add)),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'user',
                activeIcon: Icon(Icons.person_3)),
          ]),
    );
  }
}


class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecondPage'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return HomPage();
                    },
                    settings: RouteSettings(name: AppRouter.home)),
              );
            },
            child: Text('push to Home')),
      ),
    );
  }
}

