import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/constants/asset.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50, bottom: 38),
          width: 200,
          child: Image.asset(Asset.logoImage),
        ),
      ],
    );
  }
}
