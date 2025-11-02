import 'package:beprepared/beprepared.dart';
import 'package:flutter/material.dart';

abstract class INavigationService {
  Future<dynamic> navigateTo(Widget destination);
  Future<dynamic> navigateToFullScreenDialog(Widget destination);
  Future<dynamic> navigateToWithBottomNavBar(
      BuildContext context, Widget destination);
  Future<dynamic> navigateToReplacement(Widget destination);
  // Future<dynamic> navigateTo(String routeName, {Object? arguments});
  // Future<dynamic> navigateToReplacement(String routeName, {Object? arguments});
  Future<void> pop(BuildContext context);
  void popUntil(BuildContext context);
}

class NavigationService implements INavigationService {
  NavigationService._privateConstructor();
  static final NavigationService _instance =
      NavigationService._privateConstructor();
  factory NavigationService() {
    return _instance;
  }
  @override
  Future<dynamic> navigateTo(Widget destination) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Future<dynamic> navigateToWithBottomNavBar(
      BuildContext context, Widget destination) {
    return Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Future<dynamic> navigateToReplacement(Widget destination) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => false,
    );
  }

  // @override
  // Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
  //   return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  // }

  // @override
  // Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
  //   return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  // }

  @override
  Future<void> pop(BuildContext context) async {
    return Navigator.of(context).pop();
  }

  @override
  Future navigateToFullScreenDialog(Widget destination) async {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => destination,
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void popUntil(BuildContext context) {
    print("popUntil");
    return Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
