// import 'dart:async';
//
// import 'package:first_project/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'dart:math';
//
// import 'package:vibration/vibration.dart';
//
// import 'AnimationValueDemo.dart';
// import 'PopUtilWidget.dart';
//
// class TasbinPage extends StatefulWidget {
//   const TasbinPage({super.key});
//
//   @override
//   State<TasbinPage> createState() => _TasbinPageState();
// }
//
// class _TasbinPageState extends State<TasbinPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   int clickCount = 0;
//   bool is33 = true;
//   int speakStatus = 0;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int selectIdx = 0;
//
//   int get total => is33 ? 33 : 99;
//   int _loop = 0;
//   int get loop => _loop;
//
//   bool _isExpanded = false;
//   List<List<ImageProvider>> _loadedImages = [];
//
//   bool _isResourcesLoaded = false;
//
//   bool _isTerming = false;
//
//   List<TasbinZhuziModel> icons = [
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball01.png', index: 0),
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball02.png', index: 1),
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball03.png', index: 2),
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball04.png', index: 3),
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball05.png', index: 4),
//     TasbinZhuziModel(
//         iconPath: 'assets/images/home/tasbin/tasbih_pic_ball06.png', index: 5),
//   ];
//
//   List<List<String>> _images = [
//     [
//       'assets/images/home/tasbin/tasbeeh1_1.png',
//       'assets/images/home/tasbin/tasbeeh1_2.png',
//       'assets/images/home/tasbin/tasbeeh1_3.png',
//       'assets/images/home/tasbin/tasbeeh1_4.png',
//       'assets/images/home/tasbin/tasbeeh1_5.png',
//       'assets/images/home/tasbin/tasbeeh1_6.png',
//       'assets/images/home/tasbin/tasbeeh1_7.png',
//     ],
//     [
//       'assets/images/home/tasbin/tasbeeh2_1.png',
//       'assets/images/home/tasbin/tasbeeh2_2.png',
//       'assets/images/home/tasbin/tasbeeh2_3.png',
//       'assets/images/home/tasbin/tasbeeh2_4.png',
//       'assets/images/home/tasbin/tasbeeh2_5.png',
//       'assets/images/home/tasbin/tasbeeh2_6.png',
//       'assets/images/home/tasbin/tasbeeh2_7.png',
//     ],
//     [
//       'assets/images/home/tasbin/tasbeeh3_1.png',
//       'assets/images/home/tasbin/tasbeeh3_2.png',
//       'assets/images/home/tasbin/tasbeeh3_3.png',
//       'assets/images/home/tasbin/tasbeeh3_4.png',
//       'assets/images/home/tasbin/tasbeeh3_5.png',
//       'assets/images/home/tasbin/tasbeeh3_6.png',
//       'assets/images/home/tasbin/tasbeeh3_7.png',
//     ],
//     [
//       'assets/images/home/tasbin/tasbeeh4_1.png',
//       'assets/images/home/tasbin/tasbeeh4_2.png',
//       'assets/images/home/tasbin/tasbeeh4_3.png',
//       'assets/images/home/tasbin/tasbeeh4_4.png',
//       'assets/images/home/tasbin/tasbeeh4_5.png',
//       'assets/images/home/tasbin/tasbeeh4_6.png',
//       'assets/images/home/tasbin/tasbeeh4_7.png',
//     ],
//     [
//       'assets/images/home/tasbin/tasbeeh5_1.png',
//       'assets/images/home/tasbin/tasbeeh5_2.png',
//       'assets/images/home/tasbin/tasbeeh5_3.png',
//       'assets/images/home/tasbin/tasbeeh5_4.png',
//       'assets/images/home/tasbin/tasbeeh5_5.png',
//       'assets/images/home/tasbin/tasbeeh5_6.png',
//       'assets/images/home/tasbin/tasbeeh5_7.png',
//     ],
//     [
//       'assets/images/home/tasbin/tasbeeh6_1.png',
//       'assets/images/home/tasbin/tasbeeh6_2.png',
//       'assets/images/home/tasbin/tasbeeh6_3.png',
//       'assets/images/home/tasbin/tasbeeh6_4.png',
//       'assets/images/home/tasbin/tasbeeh6_5.png',
//       'assets/images/home/tasbin/tasbeeh6_6.png',
//       'assets/images/home/tasbin/tasbeeh6_7.png',
//     ],
//   ];
//
//
//   final int totalFrame = 7;// 总帧数
//   final int fps = 12;// 每秒帧数
//   int currentFeame = 0; // 当前帧
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // _controller = AnimationController(
//     //   vsync: this,
//     //   duration: Duration(milliseconds: _images[selectIdx].length * 25),
//     // );
//     //
//     // _controller.addStatusListener((status) {
//     //   if (status == AnimationStatus.completed) {
//     //     _controller.reset();
//     //   }
//     // });
//   }
//
//   void startAnimation() {
//     if (_isTerming) {
//       return;
//     }
//
//     _isTerming = true;
//
//     final frameDuration = Duration(milliseconds: (1000 / fps).round());
//     _timer = Timer.periodic(frameDuration, (timer) {
//       setState(() {
//         if (currentFeame == totalFrame - 1) {
//           _timer?.cancel();
//           currentFeame = 0;
//           _isTerming = false;
//           tasbihClick();
//         } else {
//           currentFeame = (currentFeame + 1) % totalFrame;
//           print('startAnimation: $currentFeame');
//         }
//       });
//     });
//   }
//
//   Future<void> _loadResources() async {
//     for (int groupIdx = 0; groupIdx < _images.length; groupIdx++) {
//       List<ImageProvider> loadedGroup = [];
//       for (String assetPath in _images[groupIdx]) {
//         try {
//           final image = AssetImage(assetPath);
//           await precacheImage(image, context);
//           loadedGroup.add(image);
//         } catch (e) {
//           print('Failed to load $assetPath: $e');
//         }
//       }
//       _loadedImages.add(loadedGroup);
//     }
//     print('_loadResources _loadedImages: ${_loadedImages.first.length}');
//     setState(() {
//       _isResourcesLoaded = true;
//     });
//
//   }
//
//
//   void numOfLoop() {
//     int pre = clickCount % total;
//     if (pre == total - 1) {
//       _loop += 1;
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadResources();
//   }
//
//   @override
//   void dispose() {
//     // _audioPlayer.dispose();
//     // _controller.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   void tasbihClick() {
//     if (speakStatus == 0) {
//       playSound();
//     } else if (speakStatus == 1) {
//       Vibration.vibrate();
//     }
//     // // _playAnimation();
//     // startAnimation();
//
//
//     setState(() {
//       clickCount++;
//       numOfLoop();
//     });
//   }
//
//   void playSound() async {
//     await _audioPlayer.play(AssetSource('audio/tasbin/tasbih_sound.mp3'));
//   }
//
//   Future<void> _playAnimation() async {
//     if (!_isResourcesLoaded || _controller.isAnimating) return;
//     _controller.reset();
//     _controller.forward();
//   }
//
//   void resetTasbih() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Reset Tasbih"),
//         content: const Text("Do you want to reset the tasbih count?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 clickCount = 0;
//                 is33 = true;
//                 speakStatus = 0;
//               });
//               Navigator.of(context).pop();
//             },
//             child: const Text("Confirm"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff121212),
//       appBar: AppBar(
//           title: Text('Tasbin'),
//         actions: [
//           TextButton(onPressed: () {
//             Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) {
//                   return AnimationDemo();
//             },
//                   settings: RouteSettings(name: AppRouter.animation)
//                 ));
//           }, child: Text('go next page'))
//         ],
//       ),
//       body: _isResourcesLoaded
//           ? Stack(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 16.w),
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.all(24.w),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20.w),
//                           color: Color(0xff464646)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Loop: $loop',
//                                   style: TextStyle(
//                                       color: GlobalColor.colorW,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Roboto-Regular')),
//                               SizedBox(height: 12.w),
//                               Text('Total: $clickCount',
//                                   style: TextStyle(
//                                       color: GlobalColor.colorW,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Roboto-Regular')),
//                             ],
//                           ),
//                           RichText(
//                               text: TextSpan(
//                                   text: '${clickCount % total}',
//                                   style: TextStyle(
//                                       color: GlobalColor.colorW,
//                                       fontSize: 48.sp,
//                                       fontFamily: 'Poppins-Bold'),
//                                   children: [
//                                     TextSpan(
//                                         text: '/$total',
//                                         style: TextStyle(
//                                             color: GlobalColor.colorW,
//                                             fontSize: 24.sp,
//                                             fontFamily: 'Poppins-Bold')),
//                                   ]))
//                         ],
//                       ),
//                     ),
//                      SizedBox(height: 10.w),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           startAnimation();
//                         },
//                         child: Container(
//                           color: Colors.red,
//                           child: Image(image: _loadedImages[selectIdx][currentFeame], gaplessPlayback: true)
//                           // AnimatedBuilder(
//                           //   animation: _controller,
//                           //   builder: (context, child) {
//                           //     int currentFrame = (_controller.value * _loadedImages[selectIdx].length).floor();
//                           //     print('_controller.value, ${_controller.value}, currentFrame: $currentFrame');
//                           //     return Image(
//                           //       image: ,
//                           //     );
//                           //   }
//                           // ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text("Count: $clickCount: $total"),
//                   ],
//                 ),
//                 Positioned(
//                     bottom: 36.w,
//                     left: _isExpanded ? 0 : null,
//                     right: 0,
//                     child: _selectWidget())
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   Widget _selectWidget() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _isExpanded = !_isExpanded;
//         });
//       },
//       child: AnimatedContainer(
//         clipBehavior: Clip.hardEdge,
//         duration: Duration(microseconds: 300),
//         width: _isExpanded ? double.infinity : 96.w,
//         height: 72.w,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(36.w),
//           color: GlobalColor.colorW,
//         ),
//         padding: EdgeInsets.only(top: 6.w, bottom: 6.w, left: 6.w, right: 6.w),
//         margin: EdgeInsets.symmetric(horizontal: 16.w),
//         child: _isExpanded ? _buildExpandedWidget() : _buildCollapsedWidget(),
//       ),
//     );
//   }
//
//   Widget _buildCollapsedWidget() {
//     return Stack(
//       alignment: Alignment.centerRight,
//       children: List.generate(3, (index) {
//         int reversedIndex = 2 - index; // 反向索引
//         return Positioned(
//           left: index * 12.w, // 使用正序的 index 来设置偏移量
//           child: Image.asset(
//             icons[reversedIndex].iconPath,
//             width: 60.w,
//             height: 60.w,
//           ),
//         );
//       }),
//     );
//   }
//
//   // Widget _buildCollapsedWidget() {
//   //   return Stack(
//   //     alignment: Alignment.centerRight,
//   //     children: List.generate(3, (index) {
//   //       return Positioned(
//   //         right: index * 12.w,
//   //         child: Image.asset(
//   //           icons[index],
//   //           width: 60.w,
//   //           height: 60.w,
//   //         ),
//   //       );
//   //     }).reversed.toList(), // 反转子组件的顺序
//   //   );
//   // }
//
//   Widget _buildExpandedWidget() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(
//           icons.length,
//           (index) => Padding(
//             padding: EdgeInsets.only(right: 4.w),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectIdx = icons[index].index;
//                   _isExpanded = !_isExpanded;
//                 });
//               },
//               child: Image.asset(
//                 icons[index].iconPath,
//                 width: 60.w,
//                 height: 60.w,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TasbinZhuziModel {
//   String iconPath;
//   int index;
//
//   TasbinZhuziModel({required this.index, required this.iconPath});
// }
