import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';

  void registerAction(BuildContext context) {
    print('Register button pressed');
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
                        'Register',
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
                        labelText: 'Name',
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mobile No.',
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
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hasFloatingPlaceholder: true,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () => registerAction(context),
                        child: Text('Register'),
                      ),
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
