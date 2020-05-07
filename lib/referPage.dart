import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ReferPage extends StatefulWidget {
  static const routeName = '/refer';

  @override
  _ReferPageState createState() => _ReferPageState();
  }
  
  
class _ReferPageState extends State<ReferPage>{
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _mobile_no = TextEditingController();
    void referAction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.post(
      'http://192.168.0.101:3000/doctor/post/reference',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : bearer_token,
      },
      body: jsonEncode({'mobile_no': prefs.getString('mobile_no'), 'doctor': _mobile_no.text}),
    );
    //print(response.statusCode);
    if (response.statusCode == 200) {
      await _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Refer successful!"),));
      //await Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Refer unsuccessful!"),));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Shashtho Sheba"),),
      body: Center(
        child: Form(
          key: _formKey,
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
                          'Refer',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),TextFormField(
                        controller: _mobile_no,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              referAction(context);
                            }
                          },
                          child: Text('Refer'),
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
      ),
    );
  }

}
