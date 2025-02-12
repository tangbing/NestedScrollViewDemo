
import 'package:first_project/didChangeDependenciesWidget.dart';
import 'package:first_project/key/keyExapmpleWidget.dart';
import 'package:first_project/layout_example/layoutRenderObject.dart';
import 'package:first_project/mvvm_architecture/viewModels/authenticcation_view_model.dart';
import 'package:first_project/mvvm_architecture/viewModels/counter_view_model.dart';
import 'package:first_project/mvvm_architecture/viewModels/post_view_model.dart';
import 'package:first_project/mvvm_architecture/views/authentication_view.dart';
import 'package:first_project/mvvm_architecture/views/counter_view.dart';
import 'package:first_project/mvvm_architecture/views/post_list_view.dart';
import 'package:first_project/profile_main_page.dart';
import 'package:first_project/tasbin_page.dart';
import 'package:first_project/updateWidget.dart';
import 'package:first_project/withMixWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'AnimationValueDemo.dart';
import 'HeroDemo.dart';
import 'MapWithMenuScreen/map_with_menu_screen.dart';
import 'ParallaxRecipe.dart';
import 'PopUtilWidget.dart';
import 'customPaint/CustomCheckboxTest.dart';
import 'custom_scrollview_demo.dart';
import 'keyDemoWidget.dart';
import 'layout/layout6_customMultiChildLayout.dart';


class NativeMethodChannel {
  static final NativeMethodChannel _instance = NativeMethodChannel._internal();

  NativeMethodChannel._internal(){
    print('1.执行了 NativeMethodChannel._internal() 构造函数 ');
  }

  factory NativeMethodChannel() {
    print("2. 执行了 factory NativeMethodChannel() 工厂构造函数");
    print("3. 是否需要初始化 _instance");
    return _instance; // 访问 _instance，触发其初始化
  }
}

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
 runApp(const MyApp());
 //  runApp(
 //    Container(
 //      width: 0.04,
 //      height: 0.04,
 //      color: Colors.orange,
 //      child: Center(
 //        child: Container(
 //          color: Colors.white,
 //          width: 200,
 //          height: 200,
 //          child: Align(
 //            alignment: Alignment(1, 1),
 //            child: FlutterLogo(
 //                size: 20,
 //            ),
 //          ),
 //        ),
 //      ),
 //    )
  //);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterViewModel()),
          ChangeNotifierProvider(create: (_) => PostViewModel()),
          ChangeNotifierProvider(create: (_) => AuthenticationViewModel())
        ],
        child: MapWithMenuScreen(),
      ),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Keydemowidget(),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
//       debugShowCheckedModeBanner: false,
//       home: const Scaffold(
//         body: Center(
//           child: ExampleParallax(),
//         ),
//       ),
//     );
//   }
// }

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);


  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
    (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
      Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
    BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
    localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
    (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];


// void main() {
//   print("准备调用 NativeMethodChannel()");
//  var instance1 = NativeMethodChannel();
//   print("第一次调用完成");
//
//   var instance2 = NativeMethodChannel(); // 第二次调用
//   print("第二次调用完成");
//
//   print("instance1 和 instance2 是否是同一个实例: ${instance1 == instance2}");
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // @override
//   // Widget build(BuildContext context) {
//   //  return MaterialApp(
//   //    home:  TasbinPage(),
//   //  );
//   // }
//
//  // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // TRY THIS: Try running your application with "flutter run". You'll see
//           // the application has a purple toolbar. Then, without quitting the app,
//           // try changing the seedColor in the colorScheme below to Colors.green
//           // and then invoke "hot reload" (save your changes or press the "hot
//           // reload" button in a Flutter-supported IDE, or press "r" if you used
//           // the command line to start the app).
//           //
//           // Notice that the counter didn't reset back to zero; the application
//           // state is not lost during the reload. To reset the state, use hot
//           // restart instead.
//           //
//           // This works for code too, not just values: Most code changes can be
//           // tested with just a hot reload.
//           //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: ParallaxRecipe(),
//        // initialRoute: AppRouter.popUtil,
//       //   routes: {
//       //         AppRouter.popUtil: (context) => PopUtilWidget(),
//       //         AppRouter.second: (context) => SecondPage(),
//       //         AppRouter.home: (context) => HomPage(),
//       //         AppRouter.animation: (context) => AnimationDemo(),
//       // },
//       ),
//     );
//   }
// }

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()));
        }, child: Text('跳转')),
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class OpenCircleWithDot extends StatefulWidget {
  const OpenCircleWithDot({super.key, required this.progress});
  final double progress; // 动态加载进度

  @override
  State<OpenCircleWithDot> createState() => _OpenCircleWithDotState();
}

class _OpenCircleWithDotState extends State<OpenCircleWithDot> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));


    // 开始动画
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("240° Open Circle with Dot")),
      body: Center(
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: OpenCircleWithDotPainter(progress: _progressAnimation.value),
              ),
            );
          },
        ),
      ),
    );
  }
}


class OpenCircleWithDotPainter extends CustomPainter {
  final double progress; // 0.0 ~ 1.0 的进度

  OpenCircleWithDotPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 圆的半径
    double radius = size.width / 2;

    // 中心点
    Offset center = Offset(size.width / 2, size.height / 2);

    // 背景圆环的画笔
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2) // 背景圆的颜色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0; // 圆环的宽度

    // 进度圆弧的画笔
    Paint progressPaint = Paint()
      ..color = Colors.blue // 圆弧的颜色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round; // 圆弧两端为圆角样式

    // 定义起始角度和扫描角度（240度，开口向下）
    double startAngle = (90 + 60) * pi / 180; // 起始角度（从150度开始）
    double sweepAngle = 240 * pi / 180; // 扫描角度

    // 当前加载角度
    double currentSweep = sweepAngle * progress;

    // 绘制背景圆弧
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // 绘制加载进度圆弧
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentSweep,
      false,
      progressPaint,
    );

    // 绘制加载进度的小圆点
    double dotRadius = 12.0; // 小圆点半径
    double dotAngle = startAngle + currentSweep; // 小圆点角度

    Offset dotPosition = Offset(
      center.dx + radius * cos(dotAngle), // 计算小圆点的x坐标
      center.dy + radius * sin(dotAngle), // 计算小圆点的y坐标
    );

    Paint dotPaint = Paint()
      ..color = Colors.green // 小圆点颜色
      ..style = PaintingStyle.fill;

    canvas.drawCircle(dotPosition, dotRadius, dotPaint);

    // 在中心绘制两行文本
    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // 第一行固定文本
    textPainter.text = TextSpan(
      text: 'Total Time',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - 20));

    // 第二行动态进度
    textPainter.text = TextSpan(
      text: '${(progress * 100).toInt()}%',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 每次重新绘制
  }
}

// class OpenCircleWithText extends StatefulWidget {
//   @override
//   _OpenCircleWithTextState createState() => _OpenCircleWithTextState();
// }
//
// class _OpenCircleWithTextState extends State<OpenCircleWithText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     ); // 循环动画
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("240° Open Circle with Text")),
//       body: Center(
//         child: SizedBox(
//           width: 160,
//           height: 160,
//           child: CustomPaint(
//             painter: OpenCircleWithTextPainter(progress: 0.6),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class OpenCircleWithTextPainter extends CustomPainter {
//   final double progress; // 0.0 ~ 1.0 的进度
//
//   OpenCircleWithTextPainter({required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // 圆的半径
//     double radius = size.width / 2;
//
//     // 中心点
//     Offset center = Offset(size.width / 2, size.height / 2);
//
//     // 背景圆环的画笔
//     Paint backgroundPaint = Paint()
//       ..color = Colors.grey.withOpacity(0.2) // 背景圆的颜色
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8.0; // 圆环的宽度
//
//     // 进度圆弧的画笔
//     Paint progressPaint = Paint()
//       ..color = Colors.blue // 圆弧的颜色
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8.0
//       ..strokeCap = StrokeCap.round; // 圆弧两端为圆角样式
//
//     // 定义起始角度和扫描角度（240度，开口向下）
//     double startAngle = (90 + 60) * pi / 180; // 起始角度（从150度开始）
//     double sweepAngle = 240 * pi / 180; // 扫描角度
//
//     // 动态进度值
//     double currentSweep = sweepAngle * progress;
//
//     // 绘制背景圆弧
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       backgroundPaint,
//     );
//
//     // 绘制加载进度圆弧
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       currentSweep,
//       false,
//       progressPaint,
//     );
//
//     // 在中心绘制两行文本
//     TextPainter textPainter = TextPainter(
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );
//
//     // 第一行固定文本
//     textPainter.text = TextSpan(
//       text: 'Total Time',
//       style: TextStyle(
//         color: Colors.black87,
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     textPainter.layout(minWidth: 0, maxWidth: size.width);
//     textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - 20));
//
//     // 第二行动态进度
//     textPainter.text = TextSpan(
//       text: '${(progress * 100).toInt()}%',
//       style: TextStyle(
//         color: Colors.blue,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     textPainter.layout(minWidth: 0, maxWidth: size.width);
//     textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + 5));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // 动态重绘
//   }
// }


//
// class OpenCircle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 160,
//           height: 160,
//           child: CustomPaint(
//             painter: OpenCirclePainter(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class OpenCirclePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // 定义圆的半径
//     double radius = size.width / 2;
//
//     // 背景圆环的画笔
//     Paint backgroundPaint = Paint()
//       ..color = Colors.grey.withOpacity(0.2) // 背景圆的颜色（浅灰色）
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6.0; // 圆环的宽度
//
//     // 进度圆弧的画笔
//     Paint progressPaint = Paint()
//       ..color = Colors.blue // 圆弧的颜色（蓝色，可根据需求修改）
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6.0
//       ..strokeCap = StrokeCap.round; // 圆弧两端为圆角样式
//
//     // 绘制背景圆环（360 度）
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, backgroundPaint);
//
//     // 定义圆弧的起始角度和扫描角度
//     double startAngle = (90 + 20) * pi / 180; // 起始角度（调整以确保开口朝下）
//     double sweepAngle = 320 * pi / 180; // 扫描角度（320 度）
//
//     // 绘制进度圆弧
//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
//       startAngle,
//       sweepAngle,
//       false,
//       progressPaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
//


class SymmetricProgressRing extends StatefulWidget {
  final double targetProgress; // 最终进度 (0.0 到 1.0)
  final Duration duration; // 动画持续时间

  const SymmetricProgressRing({
    Key? key,
    required this.targetProgress,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _SymmetricProgressRingState createState() => _SymmetricProgressRingState();
}

class _SymmetricProgressRingState extends State<SymmetricProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化 AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 初始化 Tween 动画
    _animation = Tween<double>(begin: 0.0, end: widget.targetProgress)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // 开始动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('circle loading process'),
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomProgressRing(
            progress: _animation.value, // 动态变化的进度值
            progressColor: Colors.red,
            backgroundColor: Colors.grey.shade300,
            strokeWidth: 10,
          );
        },
      ),
    );
  }
}

class CustomProgressRing extends StatelessWidget {
  final double progress; // 当前进度 (0.0 到 1.0)
  final double strokeWidth; // 圆环宽度
  final Color progressColor; // 进度条颜色
  final Color backgroundColor; // 背景圆环颜色

  CustomProgressRing({
    required this.progress,
    this.strokeWidth = 8.0,
    this.progressColor = Colors.red,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 背景圆环
        Transform.rotate(
          angle: pi / 2, // 开口向下
          child: CustomPaint(
            size: Size.square(200),
            painter: _SymmetricPainter(
              progress: 1.0, // 背景画满
              strokeWidth: strokeWidth,
              progressColor: backgroundColor,
            ),
          ),
        ),
        // 加载进度圆环
        Transform.rotate(
          angle: pi / 2, // 开口向下
          child: CustomPaint(
            size: Size.square(200),
            painter: _SymmetricPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              progressColor: progressColor,
            ),
          ),
        ),
        // 动态红色圆环
        Positioned(
          left: 100 +
              90 *
                  cos(pi / 2 + progress * 2 * pi * 5 / 6) - // 调整圆环中心 (x 坐标)
              12, // 红环半径一半
          top: 100 +
              90 *
                  sin(pi / 2 + progress * 2 * pi * 5 / 6) - // 调整圆环中心 (y 坐标)
              12, // 红环半径一半
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: progressColor, width: 6), // 红色边框
            ),
          ),
        ),
        // 中间文字
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SymmetricPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;

  _SymmetricPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 6/5圆环：对称弧形加载
    final sweepAngle = 2 * pi * 5 / 6 * progress; // 加载进度
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 - pi * 5 / 12, // 起始角度，确保左右对称
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
