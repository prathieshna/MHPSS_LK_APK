import 'package:mhpss_app/config/routes/navigation_service.dart';
import 'package:mhpss_app/core/localStorage/prefs_storage.dart';
import 'package:mhpss_app/core/localStorage/storage.dart';
import 'package:mhpss_app/core/use%20cases/app_functions.dart';
import 'package:get_it/get_it.dart';

final _locator = GetIt.instance;

IStorage get storage => _locator<PrefsStorage>();
IAppFunctions get appFunctions => _locator<AppFunctions>();
INavigationService get navigator => _locator<NavigationService>();

abstract class DependencyInjectionEnvironment {
  static Future<void> setup() async {
    _locator.registerLazySingleton<PrefsStorage>(() => PrefsStorage());
    _locator.registerSingleton<AppFunctions>(AppFunctions());
    _locator.registerSingleton<NavigationService>(NavigationService());
    await storage.initHive();
  }
}
