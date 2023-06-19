import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/constants/setting.dart';
import 'package:flutter_mystock/src/pages/Home/home_page.dart';
import 'package:flutter_mystock/src/pages/login/login_page.dart';
import 'package:flutter_mystock/src/config/route.dart' as custom_route;
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: custom_route.Route.getAll(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final token = snapshot.data?.getString(Setting.tokenPref) ?? '';
            if (token.isNotEmpty) {
              return const HomePage();
            }
            return const LoginPage();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
