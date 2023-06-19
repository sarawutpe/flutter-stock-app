import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/config/theme.dart' as custom_theme;
import 'package:flutter_mystock/src/pages/login/widgets/header.dart';
import 'package:flutter_mystock/src/pages/login/widgets/login_form.dart';
import 'package:flutter_mystock/src/pages/login/widgets/single_sign_on.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: custom_theme.Theme.gradient,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const Header(),
                const LoginForm(),
                const SizedBox(height: 20),
                _buildTextButton('Forgot password', onPressed: () {}),
                const SingleSignOn(),
                const SizedBox(height: 20),
                _buildTextButton("Dont't have an Account", onPressed: () {}),
                const SizedBox(height: 80)
              ],
            ),
          )
        ],
      ),
    );
  }

  TextButton _buildTextButton(String text,
          {required VoidCallback onPressed, double fontSize = 16.0}) =>
      TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.normal),
          ));
}
