import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _mobileNo = TextEditingController();
  final _email = TextEditingController();
  final _institution = TextEditingController();
  final _designation = TextEditingController();
  final _reg_number = TextEditingController();
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void registerAction(BuildContext context) async {
    // Patient patient = Patient(
    //   name: _name.text,
    //   mobileNo: _mobileNo.text,
    //   dob: _selectedDate,
    //   sex: _sex,
    //   password: _pass.text,
    // );
    // print(DateFormat.yMMMMd().format(patient.dob));
    final http.Response response = await http.post(
      'http://192.168.0.101:3000/doctor/post/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'name': _name.text, 'password': _pass.text, "email": _email.text, "institution": _institution.text,"designation": _designation.text,"mobile_no": _mobileNo.text, "reg_number" : _reg_number.text}),
    );
    if (response.statusCode == 200) {
      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Registration successful!"),));
      Navigator.pop(context);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to register patient');
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Registration unsuccessful!"),));
    }
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Shashtho Sheba")),
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
                        controller: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _mobileNo,
                        decoration: InputDecoration(
                          labelText: 'Mobile No.',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your Mobile Number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _institution,
                        decoration: InputDecoration(
                          labelText: 'Institution',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your institution';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _designation,
                        decoration: InputDecoration(
                          labelText: 'Designation',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Designation';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _reg_number,
                        decoration: InputDecoration(
                          labelText: 'Registration Number',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your reg. No.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      
                      TextFormField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please provide a password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hasFloatingPlaceholder: true,
                        ),
                        validator: (value) {
                          if (value != _pass.text) {
                            return 'Password does not match';
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              registerAction(context);
                            }
                          },
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
      ),
    );
  }
}
