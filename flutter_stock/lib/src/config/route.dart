
import 'package:flutter/cupertino.dart';
import 'package:flutter_mystock/src/pages/management/management_page.dart';
import 'package:flutter_mystock/src/pages/pages.dart';

class Route {
  static const home = '/home';
  static const login = '/login';
  static const page = '/page';
  static const management = '/management';
  static const blank = '/blank';

  static Map<String, WidgetBuilder> getAll() => _route;

  static final Map<String, WidgetBuilder> _route = {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    management: (context) => const ManagementPage(),
    blank: (context) => const BlankPage()
  };
}