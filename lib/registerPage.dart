import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './models/patient.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _sex = 'male';
  DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final _dob = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _mobileNo = TextEditingController();

  void registerAction(BuildContext context) async {
    Patient patient = Patient(
      name: _name.text,
      mobileNo: _mobileNo.text,
      dob: _selectedDate,
      sex: _sex,
      password: _pass.text,
    );
    // print(DateFormat.yMMMMd().format(patient.dob));
    final http.Response response = await http.post(
      'http://931d77e9.ngrok.io/patient/post/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient),
    );
    if (response.statusCode == 200) {
      print('success');
      Navigator.pop(context);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to register patient');
      print(response.statusCode);
    }
  }

  @override
  void dispose() {
    _dob.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Gender:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Radio(
                            value: 'male',
                            groupValue: _sex,
                            onChanged: (String value) {
                              setState(() {
                                _sex = value;
                              });
                            },
                          ),
                          Text('Male'),
                          Radio(
                            value: 'female',
                            groupValue: _sex,
                            onChanged: (String value) {
                              setState(() {
                                _sex = value;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _dob,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          hasFloatingPlaceholder: true,
                          suffixIcon: Icon(Icons.date_range),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter your Date of Birth";
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(
                                Duration(
                                  days: 36500,
                                ),
                              ),
                              initialDate: _selectedDate == null
                                  ? DateTime.now()
                                  : _selectedDate,
                              initialDatePickerMode: DatePickerMode.year,
                              lastDate: DateTime.now());
                          if (selectedDate != null) {
                            _selectedDate = selectedDate;
                            setState(() => _dob.text =
                                DateFormat.yMMMMd('en_US')
                                    .format(_selectedDate));
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                        height: 20,
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
