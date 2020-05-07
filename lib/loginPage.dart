import 'package:Doctor/doctor.dart';
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
    if (prefs.getString('jwt')!=null && prefs.getString('jwt').isNotEmpty) {
      final d = Doctor(
          name: prefs.getString('name'),
          email: prefs.getString('email'),
          mobile_no: prefs.getString('mobile_no'),
          institution: prefs.getString('institution'),
          desig: prefs.getString('designation'),
          reg_num: prefs.getString('reg_number'),
          referrer: prefs.getString('referrer'));
          final entries= await getAppointemnt();
          final entriesf=await getFutureAppointemnt ();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabbedPages(doctor: d,entries: entries,entriesf:entriesf),
        ),
      );
    }
  }

  Future<List> getAppointemnt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.get(
      'http://192.168.0.101:3000/doctor/get/appointment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : bearer_token,
      },
    );
    print(response.statusCode );
    if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body);
        return parsed;
    }
    return null;
  }
Future<List> getFutureAppointemnt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.get(
      'http://192.168.0.101:3000/doctor/get/futureAppointment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : bearer_token,
      },
    );
    print(response.statusCode );
    if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body);
        return parsed;
    }
    return null;
  }

  void loginAction(BuildContext context) async {
    final http.Response response = await http.post(
      'http://192.168.0.101:3000/doctor/post/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'mobile_no': _mobileNo.text, 'password': _pass.text}),
    );
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var parsed = jsonDecode(response.body);
      var encoded = jsonEncode(parsed['doctor_detail']);
      var doctor = jsonDecode(encoded);

      await prefs.setString('jwt', parsed['token']);
      final d = Doctor(
          name: doctor['name'],
          email: doctor['email'],
          mobile_no: doctor['mobile_no'],
          institution: doctor['institution'],
          desig: doctor['designation'],
          reg_num: doctor['reg_number'],
          referrer: doctor['referrer']);
      await prefs.setString('name', doctor['name']);
      await prefs.setString('email', doctor['email']);
      await prefs.setString('mobile_no', doctor['mobile_no']);
      await prefs.setString('institution', doctor['institution']);
      await prefs.setString('designation', doctor['designation']);
      await prefs.setString('reg_number', doctor['reg_number']);
      await prefs.setString('referrer', doctor['referrer']);

      final entries=await getAppointemnt ();
      final entriesf=await getFutureAppointemnt ();
      //await Navigator.pushNamed(context, TabbedPages.routeName);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabbedPages(doctor: d,entries: entries,entriesf: entriesf)
        ),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Invalid cardinals!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Shashtho Sheba")),
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
