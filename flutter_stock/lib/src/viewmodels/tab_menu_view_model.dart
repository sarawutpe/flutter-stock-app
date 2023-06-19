import 'package:flutter/cupertino.dart';
import 'package:flutter_mystock/src/pages/home/widgets/chart.dart';
import 'package:flutter_mystock/src/pages/home/widgets/report.dart';
import 'package:flutter_mystock/src/pages/home/widgets/stock.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabMenu {
  final String title;
  final IconData icon;
  final Widget widget;

  const TabMenu(this.title, this.widget, {required this.icon});
}

class TabMenuViewModel {
  List<TabMenu> get items => <TabMenu>[
        const TabMenu(
          'Stock',
          Stock(),
          icon: FontAwesomeIcons.box,
        ),
        const TabMenu(
          'Chart',
          Chart(),
          icon: FontAwesomeIcons.chartArea,
        ),
        const TabMenu(
          'Report',
          Report(),
          icon: FontAwesomeIcons.fileLines,
        ),
      ];
}
