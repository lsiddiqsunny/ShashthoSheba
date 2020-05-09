import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


enum futureStatus { loading, completed, error }
enum futureSelected { previous, upcoming }

class FutureAppointmentProvider extends ChangeNotifier {
  List _appointments;

  futureStatus _status = futureStatus.loading;
  futureSelected _selected = futureSelected.previous;

  FutureAppointmentProvider() {
    _fetchAppointments();
  }

  set selected(futureSelected selected) {
    _selected = selected;
    _status = futureStatus.loading;
    notifyListeners();
    _fetchAppointments();
  }

  UnmodifiableListView get appointments =>
      UnmodifiableListView(_appointments);

  futureSelected get selected => _selected;

  futureStatus get status => _status;

  void _fetchAppointments() async {
    List newList = await _getList();
    _status = futureStatus.completed;
    _appointments = newList;
    notifyListeners();
  }

  



Future<List> _getList() async {
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
}