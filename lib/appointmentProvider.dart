import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


enum Status { loading, completed, error }
enum Selected { previous, upcoming }

class AppointmentProvider extends ChangeNotifier {
  List _appointments;

  Status _status = Status.loading;
  Selected _selected = Selected.previous;

  AppointmentProvider() {
    _fetchAppointments();
  }

  set selected(Selected selected) {
    _selected = selected;
    _status = Status.loading;
    notifyListeners();
    _fetchAppointments();
  }

  UnmodifiableListView get appointments =>
      UnmodifiableListView(_appointments);

  Selected get selected => _selected;

  Status get status => _status;

  void _fetchAppointments() async {
    List newList = await _getList();
    _status = Status.completed;
    _appointments = newList;
    notifyListeners();
  }

  



Future<List> _getList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.get(
      'http://192.168.0.103:3000/doctor/get/appointment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : bearer_token,
      },
    );
    print("here"+response.statusCode.toString() );
    if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body);
        return parsed;
    }
    return null;
}
}