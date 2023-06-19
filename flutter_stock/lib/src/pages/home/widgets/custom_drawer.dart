import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/constants/setting.dart';
import 'package:flutter_mystock/src/viewmodels/menu_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mystock/src/config/route.dart' as custom_route;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildProfile(),
          ..._buildMainMenu(),
          const Spacer(),
          SafeArea(
            child: ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.grey,
              ),
              title: const Text('Logout'),
              onTap: showDialogLogout,
            ),
          ),
        ],
      ),
    );
  }

  showDialogLogout() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Logout');

              // Use shared preferences clear values
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove(Setting.tokenPref);
                Navigator.pushNamedAndRemoveUntil(
                    context, custom_route.Route.login, (route) => false);
              });
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader _buildProfile() => const UserAccountsDrawerHeader(
        accountName: Text('CMDEV'),
        accountEmail: Text('admin@example.com'),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://cdn-images-1.medium.com/max/175/1*X5PBTDQQ2Csztg3a6wofIQ@2x.png'),
        ),
      );

  List<ListTile> _buildMainMenu() {
    return MenuViewModel()
      .items
      .map(
        (item) => ListTile(
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          leading: badges.Badge(
            showBadge: item.icon == FontAwesomeIcons.inbox,
            badgeContent: const Text(
              '99',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
            ),
            child: FaIcon(
              item.icon,
              color: item.iconColor,
            ),
          ),
          onTap: () {
            item.onTap!(context);
          },
        ),
      )
      .toList();
  }
}
