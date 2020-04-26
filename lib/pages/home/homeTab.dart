import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../host.dart' as host;
import '../../models/appointment.dart';
import './item.dart';
import './appointmentList.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8,
            ),
            child: Text(
              'Appointments Today:',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          FutureBuilder<List<Item>>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? AppointmentList(data: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

Future<List<Item>> _getData() async {
  List<Appointment> data = await _getList();
  List<Item> _data = data.map<Item>((appointment) {
    return Item(appointment: appointment, isExpanded: false);
  }).toList();
  return _data;
}

Future<List<Appointment>> _getList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    host.loc +
        '/patient/get/appointment/' +
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    },
  );
  if (response.statusCode == 200) {
    return compute(_parseData, response.body);
  } else {
    print(response.statusCode);
    return [];
  }
}

List<Appointment> _parseData(String responseBody) {
  final data = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return data.map<Appointment>((json) {
    return Appointment.fromJson(json);
  }).toList();
}
