import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blank'),
        centerTitle: false,
      ),
      body: const Center(
        child: FlutterLogo(
          size: 150.0,
        ),
      ),
    );
  }
}
