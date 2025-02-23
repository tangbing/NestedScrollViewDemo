
import 'package:http/http.dart' as http;

abstract class NetworkRequest {
  Future<String> fetchData(String url);
}


class RealNetworkRequest implements NetworkRequest {
  @override
  Future<String> fetchData(String url) async {
     final response = await http.get(Uri.parse(url));
     if (response.statusCode == 200) {
       return response.body;
     } else {
       throw Exception('Failed to load data');
     }
  }
}

class CachingNetworkRequest implements NetworkRequest {

  final NetworkRequest _realRequest;
  final Map<String, String> _cache = {};

  CachingNetworkRequest(this._realRequest);

  @override
  Future<String> fetchData(String url) async {
    // 检查缓存中是否有数据
    if (_cache.containsKey(url)) {
      print('Returning cached data for $url');
      return _cache[url]!;
    }

    // 缓存中没有数据，从真实网络请求中获取
    print('Fetching data from network for $url');
    final data = await _realRequest.fetchData(url);

    // 将数据缓存起来
    _cache[url] = data;

    return data;
  }

}