import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/config/route.dart' as custom_route;
import 'package:flutter_mystock/src/config/theme.dart' as custom_theme;
import 'package:flutter_mystock/src/constants/setting.dart';
import 'package:flutter_mystock/src/utils/regex_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  String? _errorUsername;
  String? _errorPassword;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameController.text = "admin@example.com";
    passwordController.text = "1234";
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      _buildForm(),
      _buildSubmitFormButton(),
    ]);
  }

  Card _buildForm() => Card(
        margin: const EdgeInsets.only(bottom: 22, left: 22, right: 22),
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 70, left: 28, right: 28),
          child: FormInput(
            usernameController: usernameController,
            passwordController: passwordController,
            errorUsername: _errorUsername,
            errorPassword: _errorPassword,
          ),
        ),
      );

  Container _buildSubmitFormButton() => Container(
        width: 220,
        height: 50,
        decoration: _boxDecoration(),
        child: TextButton(
          onPressed: () => _onLogin(context),
          child: const Text(
            'LOGIN',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
        ),
      );

  BoxDecoration _boxDecoration() {
    const gradientStart = custom_theme.Theme.gradientStart;
    const gradientEnd = custom_theme.Theme.gradientEnd;

    boxShadowItem(Color color) => BoxShadow(
          color: color,
          offset: const Offset(1.0, 6.0),
          blurRadius: 20.0,
        );

    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          boxShadowItem(gradientStart),
          boxShadowItem(gradientEnd),
        ],
        gradient: const LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin:  FractionalOffset(0, 0),
            end:  FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0]));
  }

  void showAlerBar() {
    Flushbar(
      title: 'Incorrect username or password',
      message: 'Please try again',
      icon: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void showLoading() {
    Flushbar(
      message: 'Loading...',
      showProgressIndicator: true,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  void _onLogin(context) {
    String username = usernameController.text;
    String password = passwordController.text;

    _errorUsername = null;
    _errorPassword = null;

    if (!EmailSubmitRegexValidator().isValid(username)) {
      _errorUsername = 'The Email must be a valid email.';
    }

    if (password.length < 4) {
      _errorPassword = "Must be at least 8 characters";
    }

    if (_errorUsername == null && _errorPassword == null) {
      showLoading();
      Future.delayed(const Duration(seconds: 2)).then((value) async {
        Navigator.pop(context);
        if (username == 'admin@example.com' && password == '1234') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(Setting.tokenPref, 'xxx');
          prefs.setString(Setting.usernamePref, username);

          Navigator.pushNamed(context, custom_route.Route.home);
        } else {
          showAlerBar();
          setState(() {});
        }
      });
    } else {
      setState(() {});
    }
  }
}

class FormInput extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String? errorUsername;
  final String? errorPassword;

  const FormInput({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.errorUsername,
    required this.errorPassword,
  }) : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final _color = Colors.black54;

  late bool _obscureTextPassword;
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    _obscureTextPassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildUsername(),
        const Divider(
          height: 22,
          thickness: 1,
          indent: 13,
          endIndent: 13,
        ),
        _buildPassword()
      ],
    );
  }

  TextStyle _textStyle() =>
      TextStyle(fontWeight: FontWeight.w500, color: _color);

  TextField _buildUsername() => TextField(
        focusNode: _passwordFocusNode,
        controller: widget.usernameController,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Email Address',
            labelStyle: _textStyle(),
            errorText: widget.errorUsername,
            icon: FaIcon(
              FontAwesomeIcons.envelope,
              size: 22.0,
              color: _color,
            )),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSubmitted: (String value) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
      );

  TextField _buildPassword() => TextField(
        controller: widget.passwordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Password',
            labelStyle: _textStyle(),
            errorText: widget.errorPassword,
            suffixIcon: IconButton(
              icon: FaIcon(
                _obscureTextPassword
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: _color,
                size: 15.0,
              ),
              onPressed: () {
                setState(() {
                  _obscureTextPassword = !_obscureTextPassword;
                });
              },
            ),
            icon: FaIcon(
              FontAwesomeIcons.lock,
              size: 22.2,
              color: _color,
            )),
        obscureText: _obscureTextPassword,
      );
}
