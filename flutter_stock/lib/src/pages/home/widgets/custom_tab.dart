import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/viewmodels/tab_menu_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<TabMenu> tabsMenu;

  const CustomTabBar(this.tabsMenu, {super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
        tabs: tabsMenu
            .map((item) => Tab(
                  child: Row(
                    children: [
                      FaIcon(item.icon),
                      const SizedBox(width: 12),
                      Text(
                        item.title,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                ))
            .toList());
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
