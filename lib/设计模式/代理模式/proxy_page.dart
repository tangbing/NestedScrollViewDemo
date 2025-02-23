


import 'package:first_project/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/%E4%BB%A3%E7%90%86%E6%A8%A1%E5%BC%8F/network_request.dart';
import 'package:flutter/material.dart';

class ProxyPage extends StatefulWidget {
  const ProxyPage({super.key});

  @override
  State<ProxyPage> createState() => _ProxyPageState();
}

class _ProxyPageState extends State<ProxyPage> {

  late CachingNetworkRequest _networkRequest;

  @override
  void initState() {
    super.initState();
    _networkRequest = CachingNetworkRequest(RealNetworkRequest());
  }


  Future<void> _fetchAndShowData() async {
    try {
      final data = await _networkRequest.fetchData('https://jsonplaceholder.typicode.com/todos/1');
      print(data);
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
        child: ElevatedButton(onPressed: _fetchAndShowData, child: Text('Fetch Data')),
      ),
    );
  }
}

/*
在这个例子中，CachingNetworkRequest类充当了代理对象，
它持有一个RealNetworkRequest实例的引用，并在内部维护一个缓存来存储网络请求的结果。
当客户端调用fetchData方法时，代理对象首先检查缓存中是否有数据，如果有则直接返回缓存的数据，
否则它会通过真实网络请求对象来获取数据，并将结果缓存起来以供后续使用
 */
