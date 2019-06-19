import 'package:flutter/material.dart';
import 'navigation/navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entry Project',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: MyNavigator.routes,
    );
  }
}
