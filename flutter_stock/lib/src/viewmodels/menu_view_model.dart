import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mystock/src/config/route.dart' as custom_route;

class Menu {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function(BuildContext context)? onTap;

  const Menu(this.title,
      {required this.icon, required this.iconColor, this.onTap});
}

class MenuViewModel {
  List<Menu> get items {
    return <Menu>[
      Menu('Profile',
          icon: FontAwesomeIcons.users,
          iconColor: Colors.deepOrange, onTap: (context) {
        // todo
        Navigator.pushNamed(context, custom_route.Route.blank);
      }),
      Menu('Dashboard',
          icon: FontAwesomeIcons.chartPie,
          iconColor: Colors.green, onTap: (context) {
        // todo
        Navigator.pushNamed(context, custom_route.Route.blank);
      }),
      Menu('Inbox', icon: FontAwesomeIcons.inbox, iconColor: Colors.amber,
          onTap: (context) {
        // todo
        Navigator.pushNamed(context, custom_route.Route.blank);
      }),
      Menu('Settings', icon: FontAwesomeIcons.gears, iconColor: Colors.green,
          onTap: (context) {
        // todo
        Navigator.pushNamed(context, custom_route.Route.blank);
      }),
    ];
  }
}
