import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api.dart' as api;
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
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
              bottom: 8.0,
            ),
            child: Text(
              'Appointments Today:',
              style: Theme.of(context).textTheme.headline,
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
                  : Loading();
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
  final http.Response response = await api.fetchTodaysAppointments();
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
