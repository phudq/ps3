import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ps3_01/providers/NavigationModal.dart';
import 'package:ps3_01/utils/custom_icon_icons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  static List<Map<String, dynamic>> routes = [
    {'key': '/', 'title': Text('Search'), 'icon': Icon(Icons.search)},
    {
      'key': '/tickets',
      'title': Text('Ticket'),
      'icon': Icon(CustomIcon.ticket)
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationModal>(
      builder: (context, navigationModal, child) {
        return BottomNavigationBar(
          items: routes.map((e) {
            return BottomNavigationBarItem(icon: e['icon'], title: e['title']);
          }).toList(),
          currentIndex: routes.indexWhere(
              (element) => element['key'] == navigationModal.currentPage),
          onTap: (index) {
            String routeString = routes[index]['key'];
            if (navigationModal.currentPage == routeString) {
              return;
            }
            Provider.of<NavigationModal>(context, listen: false)
                .changePage(context, routeString);
          },
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.black45,
        );
      },
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
