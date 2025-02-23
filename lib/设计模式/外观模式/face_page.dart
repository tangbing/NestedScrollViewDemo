


import 'package:first_project/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/%E4%BB%A3%E7%90%86%E6%A8%A1%E5%BC%8F/network_request.dart';
import 'package:first_project/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/%E5%A4%96%E8%A7%82%E6%A8%A1%E5%BC%8F/datasource.dart';
import 'package:flutter/material.dart';

class FacePage extends StatefulWidget {
  const FacePage({super.key});

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {

  late DataFacade _dataFacade;

  @override
  void initState() {
    super.initState();
    _dataFacade = DataFacade(LocalDataSourceImpl(),
        NetworkingDataSourceImpl(),
        PreferencesDataSourceImpl());
  }

  Future<void> _fetchAllData() async {
    try {
        final data = await _dataFacade.getAllData();
        print(data); // 显示或处理组合后的数据
    } catch (e) {
      print('Error fetching data: $e');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('代理模式 Demo'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: _fetchAllData, child: Text('Fetch All Data')),
      ),
    );
  }
}

/*
在这个例子中，DataFacade类充当了外观角色，
它封装了LocalDataSource、
NetworkDataSource和PreferencesDataSource这三个子系统的复杂性，
并提供了一个简单的getAllData方法来并行地从这三个数据源获取数据。
客户端（即Flutter应用的UI层）只需要与DataFacade进行交互，而不需要直接处理与各个数据源通信的复杂性。


 */
