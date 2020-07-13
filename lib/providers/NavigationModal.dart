import 'package:flutter/material.dart';

class NavigationModal extends ChangeNotifier {
  String currentPage = '/';
  void changePage(context, String pageName) {
    currentPage = pageName;
    Navigator.pushNamedAndRemoveUntil(
        context, pageName, (Route<dynamic> route) => false);
    notifyListeners();
  }
}
