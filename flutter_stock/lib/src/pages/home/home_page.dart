import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/pages/home/widgets/custom_drawer.dart';
import 'package:flutter_mystock/src/pages/home/widgets/custom_tab.dart';
import 'package:flutter_mystock/src/viewmodels/tab_menu_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabsMenu = TabMenuViewModel().items;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsMenu.length,
      child: Scaffold(
        appBar: _buildAppBar(),

        drawer: const CustomDrawer(),
        body: TabBarView(
          children: _tabsMenu.map((item) => item.widget).toList(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Stock Workshop'),
      bottom: CustomTabBar(_tabsMenu),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
      ],
    );
  }
}
