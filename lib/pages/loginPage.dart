import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './mainPage.dart';
import './registerPage.dart';
import '../networking/api.dart' as api;

class LoginPage extends StatefulWidget {
  static const routeName = '/';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNo = TextEditingController();
  final _pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('jwt') != null) {
      Navigator.pushNamed(context, MainPage.routeName);
    }
  }

  void loginAction(BuildContext context) async {
    try {
      var data = await api
          .patientLogin({'mobile_no': _mobileNo.text, 'password': _pass.text});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt', data['token']);
      Navigator.pushNamed(context, MainPage.routeName);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ShasthoSheba'),
      ),
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
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _mobileNo,
                      decoration: InputDecoration(
                        labelText: 'Mobile No.',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlineButton(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        onPressed: () => loginAction(context),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterPage.routeName);
                          },
                          child: Text(
                            'Register',
                            style: Theme.of(context).textTheme.button,
                          ),
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
