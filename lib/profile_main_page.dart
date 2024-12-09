import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:first_project/ProfileLikeListView.dart';
import 'package:first_project/app_color.dart';
import 'package:first_project/utils/gm_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';


class ProfileMainPage extends StatefulWidget {
  const ProfileMainPage({super.key});

  @override
  State<ProfileMainPage> createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> tabs = ['Posts', 'likes'];
  bool _showNavBar = false;
  final GlobalKey<ExtendedNestedScrollViewState> _key =
  GlobalKey<ExtendedNestedScrollViewState>();

  // 标志位，确保监听器只添加一次
  bool _isListenerAdded = false;

  double navBarH = 100;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    // 这里要放在addPostFrameCallback，在UI初始化之后，监听currentState是有效的
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('_isListenerAdded: $_isListenerAdded, state: ${_key.currentState}');
      if (!_isListenerAdded && _key.currentState != null) {
        _key.currentState!.outerController.addListener(_scrollListener);
        _isListenerAdded = true;
      }
    });
  }


  void _scrollListener() {
    if (!_isListenerAdded || _key.currentState == null) return;

    double offset = _key.currentState!.outerController.offset;
    print('offset: $offset');
    if (offset > navBarH && !_showNavBar) {
      setState(() {
        print(
            'offset: ${_key.currentState?.outerController.offset}, showNavBar: ${_showNavBar}');
        _showNavBar = true;
      });
    } else if (_key.currentState!.outerController.offset <= navBarH &&
        _showNavBar) {
      setState(() {
        print(
            'offset: ${_key.currentState?.outerController.offset}, showNavBar: ${_showNavBar}');
        _showNavBar = false;
      });
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_isListenerAdded && _key.currentState != null) {
      _key.currentState!.outerController.removeListener(_scrollListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
    //statusBar height
    statusBarHeight +
        //pinned SliverAppBar height in header
        kToolbarHeight;

    return Scaffold(
      body: Stack(
        children: [
          ExtendedNestedScrollView(
            key: _key,
            headerSliverBuilder: (context, innerBoxIsScrolled) {

              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 437,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _topBgWidget(),
                  ),
                ),
               // 添加SliverPersistentHeader 来实现sticky navbar
               //  SliverPersistentHeader(
               //      pinned: false,
               //      delegate: _StickyNavBarDelegate(
               //        minHeight: 0,
               //        maxHeight: 100.w,
               //        child: AnimatedOpacity(opacity: _showNavBar ? 1.0 : 0.0,
               //            duration: Duration(milliseconds: 300),
               //          child: _showNavBar ? _buildStickyNavBar() : SizedBox.shrink(),
               //        ),
               //      ))
              ];
            },

            pinnedHeaderSliverHeightBuilder: () {
              return 100.w;
            },
            onlyOneScrollInBody: true,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPostLikeWidget(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      TabViewItem(Key('Tab0')),
                      TabViewItem(Key('Tab1')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(opacity: _showNavBar ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: _showNavBar ? _buildStickyNavBar() : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }


  Widget _buildStickyNavBar() {
    return Container(
      height: 100.w,
      color: const Color(0xffE5F6F2),
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: 24.w, right: 24.w, top: 40.w, bottom: 18.w),
      child: Row(
        children: [
          gmImage(
           '', // 这里可以用用户头像 URL
            localPath: 'assets/images/commons/pic_default_avatar.png',
            width: 24.w,
            height: 24.w,
            borderRadius: BorderRadius.circular(12.w),
          ),
          SizedBox(width: 8.w),
          Text(
            '显示用户名称', // 显示用户名称
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto-Medium'),
          ),
          const Spacer(),
          _buildQrButton(),
          SizedBox(width: 12.w),
          _buildSettingButton(),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }

  Widget _topBgWidget() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage('assets/images/profile/profile_top_bg.png'),
            fit: BoxFit.fill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 44.w),
            SizedBox(
              height: 56.w,
              child: Row(
                children: [
                  const Spacer(),
                  _buildQrButton(),
                  SizedBox(width: 12.w),
                  _buildSettingButton(),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
            SizedBox(height: 11.w),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: gmImage('',
                        localPath: 'assets/images/commons/pic_default_avatar.png',
                        width: 64.w,
                        height: 64.w)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('显示用户名称',
                            style: TextStyle(
                                color: GlobalColor.color000,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto-Bold')),
                        SizedBox(width: 8.w),
                        true
                            ? Image.asset(
                            'assets/images/profile/profile_pic_boy.png',
                            width: 20.w,
                            height: 20.w)
                            : Image.asset(
                            'assets/images/profile/profile_pic_girl.png',
                            width: 20.w,
                            height: 20.w)
                      ],
                    ),
                    SizedBox(height: 8.w),
                    Text('UID: 888888',
                        style: TextStyle(
                            color: GlobalColor.color999,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto Regular')),
                  ],
                )
              ],
            ),
            SizedBox(height: 22.w),
            Row(
              children: [
                Expanded(
                  child: Text('value.profileInfoModel?.introduce ?? ',
                      style: TextStyle(
                          color: GlobalColor.color666,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto Regular')),
                ),
              ],
            ),
            SizedBox(height: 21.w),
            Row(
              children: [
                _createVerticalWidget(
                    title: 'Following',
                    num: 10,
                    onTap: () => {}),
                SizedBox(width: 20.w),
                _createVerticalWidget(
                    title: 'Followers',
                    num: 0,
                    onTap: () => {}),
                SizedBox(width: 20.w),
                _createVerticalWidget(
                    title: 'Likes',
                    num: 0,
                    onTap: () => {}),
                Spacer(),
                _createEditWidget(
                    onTap: () => {}),
              ],
            ),
            SizedBox(height: 20.w),
            _preyAndAchievementWidget()
          ],
        ),
      ),
    );
  }

  Widget _buildQrButton() {
    return IconButton(
        onPressed: () async {
          print('click qr');
          showModalBottomSheet(
              context: context,
              isScrollControlled: true, // 允许全屏的弹出层
              isDismissible: false,
              backgroundColor: Colors.transparent, // 设置为透明以显示自定义遮罩层
              builder: (context) {
                // return UserQrcodeWidget();
                return Container(
                  color: Colors.red,
                  height: 300.w,
                  child: Center(child: Text('show qr')),
                );
              });
        },
        icon: Image.asset('assets/images/profile/profile_pic_qrcode.png',
            width: 32.w, height: 32.w));
  }

  Widget _buildSettingButton() {
    return IconButton(
        onPressed: () async {
          if (mounted) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Placeholder();
              },
            ));
          }
        },
        icon: Image.asset('assets/images/profile/profile_pic_setting.png',
            width: 32.w, height: 32.w));
  }

  Widget _buildPostLikeWidget() {
    return Container(
      height: 48.w,
      decoration: BoxDecoration(
        color: GlobalColor.colorW,
        gradient: const LinearGradient(
          colors: [Color(0xffF6F8FD), Color(0xffffffff)], // 渐变色
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffBDE6D2), // 阴影颜色，#80bde6d2
            offset: Offset(0, 12), // 阴影的偏移，Dx = 0, Dy = 12
            blurRadius: 12.0, // 模糊半径
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(height: 16.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                //设置tab未选中得颜色
                unselectedLabelColor: GlobalColor.color000,
                //设置tab文字得类型
                unselectedLabelStyle: TextStyle(
                    color: GlobalColor.color000,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto-Regular"),
                // //设置tab选中得颜色
                // labelColor: GlobalColor.btnPrimary,
                //设置tab文字得类型
                labelStyle: TextStyle(
                    color: GlobalColor.btnPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto-Medium"),
                indicatorColor: GlobalColor.btnPrimary,
                indicatorWeight: 4.w,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.only(bottom: -12.w),
                  borderSide:
                      BorderSide(color: GlobalColor.btnPrimary, width: 4.w),
                ),
                tabs: tabs.map((e) => Text(e)).toList(),
                onTap: (selectIdx) {
                  print('selectIdx: $selectIdx');
                  // ProfileInfoProvider _userInfoStore =
                  //     context.read<ProfileInfoProvider>();
                  // _userInfoStore.setPostAndLike(
                  //     selectIdx, true, UserInfoStore().userId);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preyAndAchievementWidget() {
    return Row(
      children: [
        Expanded(
            child: _cardWidget(
              // archievementDataList: profileInfoProvider.archievementDataList,
              bgIconPath: 'assets/images/profile/profile_cardbg_left.png',
              goIconPath: 'assets/images/profile/card_go_right.png',
              title: 'Upcoming prayer',
              desc: 'profileInfoProvider.prayLabel',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SizedBox();
                  },
                ));
                //AdsWidget.showPageAds();
              },
            )),
        SizedBox(width: 13.w),
        Expanded(
            child: _cardWidget(
              isAchievement: true,
              // archievementDataList: profileInfoProvider.archievementDataList,
              bgIconPath: 'assets/images/profile/profile_cardbg_right.png',
              goIconPath: 'assets/images/profile/card_go_left.png',
              title: 'Upcoming prayer',
              desc: '…',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SizedBox();
                  },
                ));
                //AdsWidget.showPageAds();
              },
            ))
      ],
    );
  }

  Widget _createEditWidget({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 32.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: GlobalColor.pageBg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/profile/profile_icon_edit.png',
                width: 12.w, height: 12.w),
            SizedBox(width: 2.w),
            Text('Edit',
                style: TextStyle(
                    color: GlobalColor.color000,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Roboto-Medium'))
          ],
        ),
      ),
    );
  }

  Widget _createVerticalWidget(
      {required String title, required int num, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text('$num',
              style: TextStyle(
                  color: GlobalColor.color000,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins-Bold')),
          SizedBox(height: 5.w),
          Text(title,
              style: TextStyle(
                  color: GlobalColor.color999,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto-Regular'))
        ],
      ),
    );
  }

  Widget _cardWidget(
      {required String bgIconPath,
      required String goIconPath,
      required String title,
      required String desc,
      bool isAchievement = false,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(bgIconPath), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(title,
                        style: TextStyle(
                            color: GlobalColor.pageBg,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto-Medium')),
                  ),
                  Image.asset(goIconPath, width: 42.w, height: 24.w)
                ],
              ),
              SizedBox(height: 16.w),
              Row(
                children: [
                  // if (isAchievement) _badgeOverlapWidget(archievementDataList),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(desc,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                            color: GlobalColor.pageBg,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins-Bold')),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadMoreListSource extends LoadingMoreBase<int> {
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) {
    return Future.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < 10; i++) {
        add(0);
      }
      return true;
    });
  }
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.uniqueKey);

  final Key uniqueKey;

  @override
  State<TabViewItem> createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem> with AutomaticKeepAliveClientMixin {
  late final LoadMoreListSource source = LoadMoreListSource();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget child = ExtendedVisibilityDetector(
        uniqueKey: widget.uniqueKey,
        child: LoadingMoreList<int>(
          ListConfig<int>(
            sourceList: source,
            itemBuilder: (context, item, index) {
              return Container(
                alignment: Alignment.center,
                height: 60.0,
                child: Text(': ListView$index'),
              );
            },
          )
        ));
    return child;
  }

  @override
  bool get wantKeepAlive => true;
}



