import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleSignOn {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPress;

  SingleSignOn({
    required this.icon,
    required this.backgroundColor,
    required this.onPress,
  });
}

class SingleSignOnViewModel {
  List<SingleSignOn> get items => <SingleSignOn>[
        SingleSignOn(
            icon: FontAwesomeIcons.apple,
            backgroundColor: const Color(0xFF323232),
            onPress: () {
              //todo
            }),
        SingleSignOn(
            icon: FontAwesomeIcons.google,
            backgroundColor: const Color(0xFFd7483b),
            onPress: () {
              //todo
            }),
        SingleSignOn(
            icon: FontAwesomeIcons.facebookF,
            backgroundColor: const Color(0xFF4063ae),
            onPress: () {
              //todo
            }),
        SingleSignOn(
            icon: FontAwesomeIcons.line,
            backgroundColor: const Color(0xFF21b54d),
            onPress: () {
              //todo
            }),
      ];
}
