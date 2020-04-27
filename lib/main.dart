import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './loginPage.dart';
import './registerPage.dart';
import './tabbedPages.dart';
import './referPage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        TabbedPages.routeName: (context) => TabbedPages(),
        RegisterPage.routeName: (context) => RegisterPage(),
        ReferPage.routeName: (context) => ReferPage(),
      },
    );
  }
}