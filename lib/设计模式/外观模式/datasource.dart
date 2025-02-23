
abstract class LocalDataSource {
  Future<String> getLocalData();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<String> getLocalData() async {
      await Future.delayed(Duration(seconds: 2));
      return 'Local Data';
  }
}



abstract class NetworkDataSource {
  Future<String> getNetworkData();
}

class NetworkingDataSourceImpl implements NetworkDataSource {
  @override
  Future<String> getNetworkData() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Networking Data';
  }
}


abstract class PreferencesDataSource {
  Future<String> getPreferencesData();
}

class PreferencesDataSourceImpl implements PreferencesDataSource {
  @override
  Future<String> getPreferencesData() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Local Data';
  }
}

// 外观类

class DataFacade {
  final LocalDataSource _localDataSource;
  final NetworkDataSource _networkDataSource;
  final PreferencesDataSource _preferencesDataSource;

  DataFacade(
      this._localDataSource,
      this._networkDataSource,
      this._preferencesDataSource,
      );

  Future<String> getAllData() async {
    final localData = await _localDataSource.getLocalData();
    final networkingData = await _networkDataSource.getNetworkData();
    final preferenceData = await _preferencesDataSource.getPreferencesData();

    // 组合数据并返回
    return "$localData, $networkingData, $preferenceData";
  }

}