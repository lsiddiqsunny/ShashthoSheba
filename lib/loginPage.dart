import 'package:first_app/homePage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static const routeName='/';

  void loginAction(BuildContext context) {
    print('Login Button Pressed');
    Navigator.pushNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
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
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    onPressed: ()=>loginAction(context),
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.only(left: 25, right: 25),
        ),
      ),
    );
  }
}