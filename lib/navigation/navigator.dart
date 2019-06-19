import 'package:flutter/material.dart';
import 'package:image_hasher/ui/screen_list.dart';
import 'package:image_hasher/ui/screen_main.dart';

///
/// Handles navigation in the app.
///
class MyNavigator {
  static const home = "/";
  static const list = "/list";

  static final routes = {
    MyNavigator.home: (context) => MainScreen(),
    MyNavigator.list: (context) => ImageListScreen(),
  };

  static void navigateToList(BuildContext context) {
    Navigator.of(context).pushNamed(list);
  }
}
