import 'dart:convert';

import 'package:Doctor/doctor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'appointmentList.dart';
import 'appointmentProvider.dart';
class HomeTab extends StatefulWidget {
  
  final Doctor doctor;
  HomeTab({this.doctor});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {


Future<List> getFutureAppointemnt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.get(
      'http://192.168.0.103:3000/doctor/get/futureAppointment',
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

  var data;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (context) => AppointmentProvider(),
            child: Builder(
              builder: (context) {
                return AppointmentList();
              },
            ),
          );
    
  }
}
