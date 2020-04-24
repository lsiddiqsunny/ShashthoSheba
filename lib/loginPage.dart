import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './tabbedPages.dart';
import './registerPage.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNo = TextEditingController();
  final _pass = TextEditingController();
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('jwt') != null) {
      await Navigator.pushNamed(context, TabbedPages.routeName);
    }
  }

  void loginAction(BuildContext context) async {
    final http.Response response = await http.post(
      'https://50b80655.ngrok.io/doctor/post/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'mobile_no': _mobileNo.text, 'password': _pass.text}),
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', response.body);
      await Navigator.pushNamed(context, TabbedPages.routeName);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Invalid cardinals!"),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _mobileNo,
                      decoration: InputDecoration(
                        labelText: 'Mobile No.',
                        hasFloatingPlaceholder: true,
                      ),
                      validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your mobile No.';
                          }
                          return null;
                        },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _pass,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () => loginAction(context),
                        child: Text('Login'),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text('Don\'t have an account?'),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterPage.routeName);
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              margin: EdgeInsets.only(left: 25, right: 25),
            ),
          ],
        ),
      ),
    );
  }
}
