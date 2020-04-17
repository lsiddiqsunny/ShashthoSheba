import 'package:flutter/material.dart';

import './tabbedPages.dart';
import './registerPage.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/';

  void loginAction(BuildContext context) {
    print('Login Button Pressed');
    Navigator.pushNamed(context, TabbedPages.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hasFloatingPlaceholder: true,
                      ),
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
