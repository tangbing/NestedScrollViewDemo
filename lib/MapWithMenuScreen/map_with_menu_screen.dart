import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWithMenuScreen extends StatefulWidget {
  const MapWithMenuScreen({super.key});

  @override
  State<MapWithMenuScreen> createState() => _MapWithMenuScreenState();
}

class _MapWithMenuScreenState extends State<MapWithMenuScreen> {
  double menuHeight = 150;

  LatLng _center = LatLng(22.547, 114.085947); // 默认设置为旧金山

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Menu'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: FlutterMap(
                  options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 8.0,
                     ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                MarkerLayer(markers: [
                  Marker(
                      point: _center, child: const Icon(Icons.location_on, size: 40)),
                ])
              ])),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black26),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        print("Searching for: ${searchController.text}");
                        setState(() {
                          _center = LatLng(34.0522, -118.2437); // 设置为洛杉矶
                        });
                      },
                      icon: Icon(Icons.search))
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 100,
              child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.1,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // 横向按钮
                          Container(
                            height: 44,
                            color: Colors.white,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildMenuButton("Button 1", Colors.black26),
                                 SizedBox(width: 10),
                                _buildMenuButton("Button 2", Colors.yellow),
                                SizedBox(width: 10),
                                _buildMenuButton("Button 3", Colors.purple),
                              ],
                            ),
                          ),
                          // 菜单项
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    title: Text("Menu item #$index"));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, Color bgColor) {
    return Container(
      alignment: Alignment.center,
      width: 44,
        height: 2,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}

/*
 Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    menuHeight -= details.primaryDelta!;
                    if (menuHeight < 100) menuHeight = 100;
                    if (menuHeight > 300) menuHeight = 300;
                  });
                },
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: menuHeight,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildMenuButton('menu 1'),
                              _buildMenuButton('menu 2'),
                              _buildMenuButton('menu 3'),
                            ],
                          ),
                        ),
                        Expanded(child:
                        ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                          return ListTile(title: Text('Menu item: $index'));
                        },))
                      ],
                    ),
                ),
              ),
          )
 */
