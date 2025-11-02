abstract class IStorage {
  // Hive DataBase
  Future<void> initHive();
  Future<void> clearHiveValue(String key);
  Future<bool> clearHiveAll();
  Future<void> setHiveValue(String key, dynamic value);
  Future<dynamic> getHiveValue(String key);

  // Future<void> setAuthToken(String authToken);
  // String? get getAuthToken;
}
