import 'package:beprepared/core/resources/all_imports.dart';

class PrefsStorage implements IStorage {
  // static late SharedPreferences _prefs;
  static late Box _hiveBox;

  static const atoarsBox = 'atocarsBox';
  // static const authToken = 'authToken';
  // static const authUser = 'authUser';

  // Initialize Hive
  @override
  Future<void> initHive() async {
    await Hive.initFlutter();

    _hiveBox = await Hive.openBox(atoarsBox);

    Hive.registerAdapter(ResourceModelAdapter());
    await Hive.openBox<ResourceModel>('favoritesBox');
    Hive.registerAdapter(DownloadedFileAdapter());
    Hive.registerAdapter(DownloadLanguageTranslationAdapter());
    await Hive.openBox<DownloadedFile>('downloads');
  }

  // Clear all values in Hive
  @override
  Future<bool> clearHiveAll() async {
    await _hiveBox.clear();
    return true;
  }

  // Clear a specific value by key
  @override
  Future<void> clearHiveValue(String key) async {
    await _hiveBox.delete(key);
  }

  // Set a value in Hive
  @override
  Future<void> setHiveValue(String key, dynamic value) async {
    await _hiveBox.put(key, value);
  }

  // Get a value from Hive
  @override
  Future<dynamic> getHiveValue(String key) async {
    return await _hiveBox.get(key);
  }

  // @override
  // Future<void> setAuthToken(String token) async {
  //   await _hiveBox.put(authToken, token);
  // }

  // @override
  // String? get getAuthToken {
  //   return _hiveBox.get(authToken);
  // }
}
