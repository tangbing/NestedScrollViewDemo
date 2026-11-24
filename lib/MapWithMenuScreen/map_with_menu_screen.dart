import 'dart:math' as math;

import 'package:amap_map/amap_map.dart' as amap;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:x_amap_base/x_amap_base.dart' as amap_base;

class MapWithMenuScreen extends StatefulWidget {
  const MapWithMenuScreen({super.key});

  @override
  State<MapWithMenuScreen> createState() => _MapWithMenuScreenState();
}

class _MapWithMenuScreenState extends State<MapWithMenuScreen> {
  static const _androidAmapKey = String.fromEnvironment('AMAP_ANDROID_KEY');
  static const _iosAmapKey = String.fromEnvironment('AMAP_IOS_KEY');
  static const _fallbackLocation = amap_base.LatLng(22.547, 114.085947);
  static const _minimumFocusZoom = 14.0;
  static const _collapsedSheetSize = 0.21;
  static const _middleSheetSize = 0.44;

  static const _demoSpots = <_FishingSpot>[
    _FishingSpot(
      id: 'lianhuashan',
      name: '莲花山公园湖畔',
      locationName: '福田区莲花街道莲花山公园东南侧',
      point: amap_base.LatLng(22.5553, 114.0596),
      tags: ['野钓', '免费', '安静'],
    ),
    _FishingSpot(
      id: 'xiangmihu',
      name: '香蜜湖钓点',
      locationName: '福田区香蜜湖街道香梅路附近',
      point: amap_base.LatLng(22.5384, 114.0329),
      tags: ['鲫鱼', '鲤鱼', '交通方便'],
    ),
    _FishingSpot(
      id: 'yinhu',
      name: '银湖山郊野钓点',
      locationName: '罗湖区银湖山郊野公园南侧',
      point: amap_base.LatLng(22.5906, 114.1030),
      tags: ['野钓', '水质好', '停车'],
    ),
    _FishingSpot(
      id: 'meilin',
      name: '梅林水库北岸',
      locationName: '福田区梅林水库绿道北侧',
      point: amap_base.LatLng(22.5788, 114.0392),
      tags: ['水库', '景色好', '步行'],
    ),
    _FishingSpot(
      id: 'buji',
      name: '布吉河休闲钓点',
      locationName: '龙岗区布吉河沿岸亲水平台',
      point: amap_base.LatLng(22.6087, 114.1232),
      tags: ['休闲', '亲水', '公共交通'],
    ),
    _FishingSpot(
      id: 'honghu',
      name: '洪湖公园东湖岸',
      locationName: '罗湖区洪湖公园东门附近',
      point: amap_base.LatLng(22.5695, 114.1260),
      tags: ['公园', '方便', '人气'],
    ),
  ];

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteSpotIds = <String>{};

  amap.AMapController? _mapController;
  _FishingSpot? _selectedSpot;
  _FishingSpot? _longPressedSpot;
  _FishingSpot? _pendingTrajectorySpot;
  amap_base.LatLng? _trajectoryStart;
  amap_base.LatLng? _trajectoryEnd;
  String? _trajectoryDestinationName;
  amap_base.LatLng _currentLocation = _fallbackLocation;
  double _sheetExtent = _middleSheetSize;
  double _mapZoom = 12.5;
  int _selectedCategory = 0;
  int _selectedBottomItem = 0;
  bool _privacyAccepted = false;
  bool _privacyPromptShowing = false;
  bool _hasLocationPermission = false;
  bool _hasRealLocation = false;
  bool _hasCenteredOnLocation = false;
  bool _isLocating = false;
  bool _isDrawingTrajectory = false;
  String? _locationError;

  bool get _supportsAmap {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool get _hasAmapKey {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidAmapKey.isNotEmpty;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosAmapKey.isNotEmpty;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (_supportsAmap && _hasAmapKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAmapPrivacyDialog();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final locationButtonBottom =
              constraints.maxHeight * _sheetExtent + 16;

          return Stack(
            children: [
              Positioned.fill(
                child: _buildMap(),
              ),
              _buildMapStatusChip(),
              _buildTrajectoryControls(locationButtonBottom + 64),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 90),
                curve: Curves.easeOut,
                right: 16,
                bottom: locationButtonBottom,
                child: FloatingActionButton.small(
                  heroTag: 'current-location',
                  tooltip: '回到当前位置',
                  onPressed: _moveToCurrentLocation,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.my_location_rounded),
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if ((_sheetExtent - notification.extent).abs() > 0.001) {
                    setState(() => _sheetExtent = notification.extent);
                  }
                  return false;
                },
                child: DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: _middleSheetSize,
                  minChildSize: _collapsedSheetSize,
                  maxChildSize: 1,
                  snap: true,
                  snapSizes: const [_middleSheetSize],
                  snapAnimationDuration: const Duration(milliseconds: 260),
                  builder: (context, scrollController) {
                    return _FishingMenuSheet(
                      scrollController: scrollController,
                      extent: _sheetExtent,
                      topInset: MediaQuery.paddingOf(context).top,
                      searchController: _searchController,
                      spots: _visibleSpots,
                      selectedSpot: _selectedSpot,
                      favoriteSpotIds: _favoriteSpotIds,
                      selectedCategory: _selectedCategory,
                      selectedBottomItem: _selectedBottomItem,
                      distanceTextFor: _distanceText,
                      onSearchChanged: (_) => setState(() {}),
                      onSearchSubmitted: (_) => _searchDemoSpot(),
                      onCategoryChanged: (index) {
                        setState(() => _selectedCategory = index);
                      },
                      onBottomItemChanged: (index) {
                        setState(() => _selectedBottomItem = index);
                      },
                      onSpotTap: _selectSpotFromMenu,
                      onFavorite: _toggleFavorite,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    if (!_supportsAmap) {
      return const _MapMessage(
        icon: Icons.phone_android_rounded,
        title: '高德地图仅支持 Android 和 iOS',
        message: '请在 Android 或 iPhone 真机/模拟器上运行这个页面。',
      );
    }
    if (!_hasAmapKey) {
      return const _MapMessage(
        icon: Icons.key_off_rounded,
        title: '尚未配置高德地图 Key',
        message: '请申请 Android/iOS Key，并使用 --dart-define 注入后重新启动。',
      );
    }
    if (!_privacyAccepted) {
      return _MapMessage(
        icon: Icons.privacy_tip_outlined,
        title: '需要同意地图与定位服务',
        message: '同意后才能初始化高德 SDK、显示地图并获取当前位置。',
        actionLabel: '查看并同意',
        onAction: _showAmapPrivacyDialog,
      );
    }

    amap.AMapInitializer.init(
      context,
      apiKey: const amap_base.AMapApiKey(
        androidKey: _androidAmapKey,
        iosKey: _iosAmapKey,
      ),
    );
    amap.AMapInitializer.updatePrivacyAgree(
      const amap_base.AMapPrivacyStatement(
        hasContains: true,
        hasShow: true,
        hasAgree: true,
      ),
    );

    return amap.AMapWidget(
      initialCameraPosition: const amap.CameraPosition(
        target: _fallbackLocation,
        zoom: 12.5,
      ),
      minMaxZoomPreference: const amap.MinMaxZoomPreference(3, 20),
      myLocationStyleOptions: amap.MyLocationStyleOptions(
        _hasLocationPermission,
        circleFillColor: Colors.blue.withValues(alpha: 0.12),
        circleStrokeColor: Colors.blue.withValues(alpha: 0.55),
        circleStrokeWidth: 1,
      ),
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      onMapCreated: (controller) {
        _mapController = controller;
        if (_hasRealLocation) _moveToCurrentLocation();
      },
      onCameraMoveEnd: (position) => _mapZoom = position.zoom,
      onTap: _handleMapTap,
      onLongPress: _selectLongPressedPoint,
      onLocationChanged: _handleMapLocationChanged,
      buildingsEnabled: true,
      compassEnabled: false,
      scaleEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: false,
    );
  }

  Widget _buildMapStatusChip() {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      left: 12,
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0.94),
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _locationError == null
                    ? Icons.my_location_rounded
                    : Icons.location_disabled_rounded,
                size: 17,
                color: _locationError == null ? null : colorScheme.error,
              ),
              const SizedBox(width: 6),
              Text(_locationStatusText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrajectoryControls(double bottom) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasPoint = _trajectoryStart != null;
    final hasTrajectory = _trajectoryStart != null && _trajectoryEnd != null;

    String? message;
    if (_isDrawingTrajectory) {
      message = hasPoint ? '请在地图上点击终点' : '请在地图上点击起点';
    } else if (hasTrajectory) {
      final destinationName = _trajectoryDestinationName;
      message = destinationName == null
          ? '轨迹距离 ${_trajectoryDistanceText!}'
          : '到$destinationName · ${_trajectoryDistanceText!}';
    } else if (_pendingTrajectorySpot != null) {
      message = '正在获取当前位置…';
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      right: 16,
      bottom: bottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message != null) ...[
            Material(
              color: colorScheme.surface.withValues(alpha: 0.96),
              elevation: 2,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasTrajectory
                          ? Icons.straighten_rounded
                          : Icons.touch_app_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      message,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasPoint) ...[
                FloatingActionButton.small(
                  heroTag: 'clear-trajectory',
                  tooltip: '清除轨迹',
                  onPressed: _clearTrajectory,
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.error,
                  child: const Icon(Icons.delete_outline_rounded),
                ),
                const SizedBox(width: 8),
              ],
              FloatingActionButton.extended(
                heroTag: 'draw-trajectory',
                tooltip: _isDrawingTrajectory ? '取消绘制' : '绘制两点轨迹',
                onPressed: _isDrawingTrajectory
                    ? _cancelTrajectoryDrawing
                    : _startTrajectoryDrawing,
                icon: Icon(
                  _isDrawingTrajectory
                      ? Icons.close_rounded
                      : Icons.route_rounded,
                ),
                label: Text(
                  _isDrawingTrajectory
                      ? '取消'
                      : hasTrajectory
                          ? '重新绘制'
                          : '绘制轨迹',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _locationStatusText {
    if (!_hasAmapKey) return '高德 Key 未配置';
    if (!_privacyAccepted) return '等待地图授权';
    if (_isLocating) return '正在定位…';
    if (_locationError != null) return _locationError!;
    if (_hasRealLocation) return '定位成功';
    return '等待定位';
  }

  Future<void> _showAmapPrivacyDialog() async {
    if (!mounted || _privacyAccepted || _privacyPromptShowing) return;
    _privacyPromptShowing = true;
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.map_outlined),
          title: const Text('启用地图与定位服务'),
          content: const Text(
            '为了显示高德地图、当前位置和附近钓点，本页面需要使用高德地图 SDK，并处理设备定位信息。你可以拒绝，拒绝后地图和定位功能将保持关闭。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('暂不启用'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('同意并启用'),
            ),
          ],
        );
      },
    );
    _privacyPromptShowing = false;
    if (accepted != true || !mounted) return;

    // 高德要求在实例化地图 SDK 之前完成隐私合规设置。
    setState(() => _privacyAccepted = true);
    await _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    if (!await geolocator.Geolocator.isLocationServiceEnabled()) {
      if (!mounted) return;
      setState(() {
        _hasLocationPermission = false;
        _isLocating = false;
        _locationError = '请开启系统定位服务';
      });
      return;
    }

    var permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
    }
    final granted = permission == geolocator.LocationPermission.whileInUse ||
        permission == geolocator.LocationPermission.always;
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = granted;
      _locationError = granted
          ? null
          : permission == geolocator.LocationPermission.deniedForever
              ? '定位权限已被永久拒绝'
              : '未授予定位权限';
    });
    if (granted) _startLocation();
  }

  void _startLocation() {
    if (!_privacyAccepted || !_hasLocationPermission) return;
    if (mounted) {
      setState(() {
        _isLocating = true;
        _locationError = null;
      });
    }
  }

  void _handleMapLocationChanged(amap_base.AMapLocation location) {
    _applyLocation(location.latLng);
  }

  void _applyLocation(amap_base.LatLng location) {
    if (!mounted) return;
    final shouldCenter = !_hasCenteredOnLocation;
    final pendingSpot = _pendingTrajectorySpot;
    setState(() {
      _currentLocation = location;
      _hasRealLocation = true;
      _isLocating = false;
      _locationError = null;
      if (shouldCenter) _hasCenteredOnLocation = true;
      if (pendingSpot != null) {
        _pendingTrajectorySpot = null;
        _trajectoryStart = location;
        _trajectoryEnd = pendingSpot.point;
        _trajectoryDestinationName = pendingSpot.name;
        _isDrawingTrajectory = false;
      }
    });
    if (pendingSpot != null) {
      _showCompleteTrajectory();
    } else if (shouldCenter) {
      _moveToCurrentLocation();
    }
  }

  List<_FishingSpot> get _visibleSpots {
    final keyword = _searchController.text.trim().toLowerCase();
    var result = _demoSpots.where((spot) {
      return keyword.isEmpty ||
          spot.name.toLowerCase().contains(keyword) ||
          spot.locationName.toLowerCase().contains(keyword) ||
          spot.tags.any((tag) => tag.toLowerCase().contains(keyword));
    }).toList();

    switch (_selectedCategory) {
      case 1:
        result = result.reversed.toList();
      case 2:
        result.sort((a, b) =>
            _distanceMeters(a.point).compareTo(_distanceMeters(b.point)));
      case 3:
        result =
            result.where((spot) => _favoriteSpotIds.contains(spot.id)).toList();
    }
    return result;
  }

  Set<amap.Marker> _buildMarkers() {
    final spots = <_FishingSpot>[
      ..._demoSpots,
      if (_longPressedSpot case final spot?) spot,
    ];

    return {
      for (final spot in spots)
        amap.Marker(
          position: spot.point,
          // 使用高德原生默认 Marker，避免插件为着色图标解析 Flutter
          // asset 时尚未初始化 FlutterLoader，导致整张平台地图创建失败。
          icon: amap.BitmapDescriptor.defaultMarker,
          infoWindow: amap.InfoWindow(
            title: spot.name,
            snippet: spot.locationName,
          ),
          onTap: (_) => _selectSpot(spot),
        ),
      if (_trajectoryStart case final start?)
        amap.Marker(
          position: start,
          icon: amap.BitmapDescriptor.defaultMarker,
          infoWindow: amap.InfoWindow(
            title: '轨迹起点',
            snippet: _coordinateText(start),
          ),
        ),
      if (_trajectoryEnd case final end?)
        amap.Marker(
          position: end,
          icon: amap.BitmapDescriptor.defaultMarker,
          infoWindow: amap.InfoWindow(
            title: '轨迹终点',
            snippet: _coordinateText(end),
          ),
        ),
    };
  }

  Set<amap.Polyline> _buildPolylines() {
    final start = _trajectoryStart;
    final end = _trajectoryEnd;
    if (start == null || end == null) return const <amap.Polyline>{};

    return {
      amap.Polyline(
        points: [start, end],
        width: 8,
        color: const Color(0xFF6F4BC3),
        geodesic: true,
        capType: amap.CapType.round,
        joinType: amap.JoinType.round,
      ),
    };
  }

  void _startTrajectoryDrawing() {
    setState(() {
      _isDrawingTrajectory = true;
      _pendingTrajectorySpot = null;
      _trajectoryStart = null;
      _trajectoryEnd = null;
      _trajectoryDestinationName = null;
      _selectedSpot = null;
    });
    _animateSheetTo(_collapsedSheetSize);
  }

  void _cancelTrajectoryDrawing() {
    setState(() {
      _isDrawingTrajectory = false;
      if (_trajectoryEnd == null) _trajectoryStart = null;
    });
  }

  void _clearTrajectory() {
    setState(() {
      _isDrawingTrajectory = false;
      _pendingTrajectorySpot = null;
      _trajectoryStart = null;
      _trajectoryEnd = null;
      _trajectoryDestinationName = null;
    });
  }

  void _handleMapTap(amap_base.LatLng point) {
    if (!_isDrawingTrajectory) {
      _clearSelection();
      return;
    }

    if (_trajectoryStart == null) {
      setState(() => _trajectoryStart = point);
      return;
    }

    setState(() {
      _trajectoryEnd = point;
      _trajectoryDestinationName = null;
      _isDrawingTrajectory = false;
    });
    _showCompleteTrajectory();
  }

  void _showCompleteTrajectory() {
    final start = _trajectoryStart;
    final end = _trajectoryEnd;
    if (start == null || end == null) return;

    final samePoint = (start.latitude - end.latitude).abs() < 0.000001 &&
        (start.longitude - end.longitude).abs() < 0.000001;
    if (samePoint) {
      _focusMapOn(start);
      return;
    }

    final bounds = amap_base.LatLngBounds(
      southwest: amap_base.LatLng(
        math.min(start.latitude, end.latitude),
        math.min(start.longitude, end.longitude),
      ),
      northeast: amap_base.LatLng(
        math.max(start.latitude, end.latitude),
        math.max(start.longitude, end.longitude),
      ),
    );
    _mapController?.moveCamera(
      amap.CameraUpdate.newLatLngBounds(bounds, 72),
      duration: 500,
    );
  }

  void _selectSpot(_FishingSpot spot) {
    setState(() => _selectedSpot = spot);
    _focusMapOn(spot.point);
    _animateSheetTo(_middleSheetSize);
  }

  void _selectSpotFromMenu(_FishingSpot spot) {
    setState(() {
      _selectedSpot = spot;
      _isDrawingTrajectory = false;

      if (_hasRealLocation) {
        _pendingTrajectorySpot = null;
        _trajectoryStart = _currentLocation;
        _trajectoryEnd = spot.point;
        _trajectoryDestinationName = spot.name;
      } else {
        _pendingTrajectorySpot = spot;
        _trajectoryStart = null;
        _trajectoryEnd = null;
        _trajectoryDestinationName = null;
      }
    });
    _animateSheetTo(_collapsedSheetSize);

    if (_hasRealLocation) {
      _showCompleteTrajectory();
    } else {
      _prepareLocationForTrajectory();
    }
  }

  Future<void> _prepareLocationForTrajectory() async {
    if (!_privacyAccepted) {
      await _showAmapPrivacyDialog();
      return;
    }
    if (!_hasLocationPermission) {
      await _requestLocationPermission();
      return;
    }
    _startLocation();
  }

  void _selectLongPressedPoint(amap_base.LatLng point) {
    final spot = _FishingSpot(
      id: 'long-pressed-point',
      name: '地图选点',
      locationName:
          '北纬 ${point.latitude.toStringAsFixed(6)}，东经 ${point.longitude.toStringAsFixed(6)}',
      point: point,
      tags: const ['自定义', '地图选点'],
    );

    setState(() {
      _longPressedSpot = spot;
      _selectedSpot = spot;
    });
    _focusMapOn(point);
    _animateSheetTo(_middleSheetSize);
  }

  void _clearSelection() {
    if (_selectedSpot == null) return;
    setState(() => _selectedSpot = null);
  }

  void _focusMapOn(amap_base.LatLng point) {
    final targetZoom = math.max(_mapZoom, _minimumFocusZoom);
    _mapZoom = targetZoom;
    _mapController?.moveCamera(
      amap.CameraUpdate.newLatLngZoom(point, targetZoom),
      duration: 350,
    );
  }

  Future<void> _moveToCurrentLocation() async {
    if (!_privacyAccepted) {
      await _showAmapPrivacyDialog();
      return;
    }
    if (!_hasLocationPermission) {
      await _requestLocationPermission();
      return;
    }
    if (!_hasRealLocation) {
      _startLocation();
      return;
    }
    _mapZoom = _minimumFocusZoom;
    await _mapController?.moveCamera(
      amap.CameraUpdate.newLatLngZoom(
        _currentLocation,
        _minimumFocusZoom,
      ),
      duration: 450,
    );
  }

  void _searchDemoSpot() {
    FocusManager.instance.primaryFocus?.unfocus();
    final spots = _visibleSpots;
    if (spots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('静态数据中没有找到该钓点')),
      );
      return;
    }
    _selectSpotFromMenu(spots.first);
  }

  void _toggleFavorite(_FishingSpot spot) {
    setState(() {
      if (!_favoriteSpotIds.remove(spot.id)) {
        _favoriteSpotIds.add(spot.id);
      }
    });
  }

  void _animateSheetTo(double size) {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  double _distanceMeters(amap_base.LatLng point) {
    return _distanceBetween(_currentLocation, point);
  }

  double _distanceBetween(
    amap_base.LatLng first,
    amap_base.LatLng second,
  ) {
    const earthRadiusMeters = 6371000.0;
    final latitude1 = _degreesToRadians(first.latitude);
    final latitude2 = _degreesToRadians(second.latitude);
    final latitudeDelta = _degreesToRadians(second.latitude - first.latitude);
    final longitudeDelta =
        _degreesToRadians(second.longitude - first.longitude);
    final haversine =
        math.sin(latitudeDelta / 2) * math.sin(latitudeDelta / 2) +
            math.cos(latitude1) *
                math.cos(latitude2) *
                math.sin(longitudeDelta / 2) *
                math.sin(longitudeDelta / 2);
    return earthRadiusMeters *
        2 *
        math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  String _distanceText(amap_base.LatLng point) {
    return _formatDistance(_distanceMeters(point));
  }

  String? get _trajectoryDistanceText {
    final start = _trajectoryStart;
    final end = _trajectoryEnd;
    if (start == null || end == null) return null;
    return _formatDistance(_distanceBetween(start, end));
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _coordinateText(amap_base.LatLng point) {
    return '${point.latitude.toStringAsFixed(6)}, '
        '${point.longitude.toStringAsFixed(6)}';
  }
}

class _FishingMenuSheet extends StatelessWidget {
  const _FishingMenuSheet({
    required this.scrollController,
    required this.extent,
    required this.topInset,
    required this.searchController,
    required this.spots,
    required this.selectedSpot,
    required this.favoriteSpotIds,
    required this.selectedCategory,
    required this.selectedBottomItem,
    required this.distanceTextFor,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onCategoryChanged,
    required this.onBottomItemChanged,
    required this.onSpotTap,
    required this.onFavorite,
  });

  static const _categories = ['推荐', '最新', '距离', '我的'];

  final ScrollController scrollController;
  final double extent;
  final double topInset;
  final TextEditingController searchController;
  final List<_FishingSpot> spots;
  final _FishingSpot? selectedSpot;
  final Set<String> favoriteSpotIds;
  final int selectedCategory;
  final int selectedBottomItem;
  final String Function(amap_base.LatLng point) distanceTextFor;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final ValueChanged<int> onCategoryChanged;
  final ValueChanged<int> onBottomItemChanged;
  final ValueChanged<_FishingSpot> onSpotTap;
  final ValueChanged<_FishingSpot> onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expansionProgress = ((extent - 0.9) / 0.1).clamp(0.0, 1.0);
    final safeTop = topInset * expansionProgress;
    final topRadius = 26.0 * (1 - expansionProgress);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, safeTop + 10, 16, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _MenuSearchField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        onSubmitted: onSearchSubmitted,
                      ),
                      const SizedBox(height: 4),
                      _CategoryBar(
                        labels: _categories,
                        selectedIndex: selectedCategory,
                        onSelected: onCategoryChanged,
                      ),
                    ],
                  ),
                ),
              ),
              if (spots.isEmpty)
                const SliverToBoxAdapter(child: _EmptySpotState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 104),
                  sliver: SliverList.separated(
                    itemCount: spots.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final spot = spots[index];
                      return _FishingSpotListTile(
                        spot: spot,
                        distanceText: distanceTextFor(spot.point),
                        isSelected: selectedSpot?.id == spot.id,
                        isFavorite: favoriteSpotIds.contains(spot.id),
                        onTap: () => onSpotTap(spot),
                        onFavorite: () => onFavorite(spot),
                      );
                    },
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomMenuBar(
              selectedIndex: selectedBottomItem,
              onSelected: onBottomItemChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSearchField extends StatelessWidget {
  const _MenuSearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '搜索附近钓点 / 鱼种',
        prefixIcon: const Icon(Icons.search_rounded, size: 21),
        suffixIcon: const Icon(Icons.tune_rounded, size: 20),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.58),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onSelected(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      labels[index],
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: selectedIndex == index
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: selectedIndex == index
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: selectedIndex == index ? 22 : 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FishingSpotListTile extends StatelessWidget {
  const _FishingSpotListTile({
    required this.spot,
    required this.distanceText,
    required this.isSelected,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final _FishingSpot spot;
  final String distanceText;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.38)
          : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.phishing_rounded,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            spot.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InkResponse(
                          radius: 20,
                          onTap: onFavorite,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 20,
                              color: isFavorite
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        for (final tag in spot.tags.take(3))
                          _SpotTag(label: tag),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          distanceText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '· ${spot.locationName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotTag extends StatelessWidget {
  const _SpotTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            color: colorScheme.onSecondaryContainer,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _EmptySpotState extends StatelessWidget {
  const _EmptySpotState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 120),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          const Text('没有找到符合条件的钓点'),
        ],
      ),
    );
  }
}

class _BottomMenuBar extends StatelessWidget {
  const _BottomMenuBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.96),
      elevation: 10,
      shadowColor: Colors.black12,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              _BottomMenuItem(
                label: '首页',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                isSelected: selectedIndex == 0,
                onTap: () => onSelected(0),
              ),
              _BottomMenuItem(
                label: '发布',
                icon: Icons.add_circle_outline_rounded,
                selectedIcon: Icons.add_circle_rounded,
                isSelected: selectedIndex == 1,
                onTap: () => onSelected(1),
              ),
              _BottomMenuItem(
                label: '我的',
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                isSelected: selectedIndex == 2,
                onTap: () => onSelected(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomMenuItem extends StatelessWidget {
  const _BottomMenuItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FishingSpot {
  const _FishingSpot({
    required this.id,
    required this.name,
    required this.locationName,
    required this.point,
    required this.tags,
  });

  final String id;
  final String name;
  final String locationName;
  final amap_base.LatLng point;
  final List<String> tags;
}

class _MapMessage extends StatelessWidget {
  const _MapMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.58),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 44, color: colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
