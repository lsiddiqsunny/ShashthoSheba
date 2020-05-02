import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';

import '../../models/appointment.dart';
import '../../api.dart' as api;

enum Status { loading, completed, error }
enum Selected { previous, upcoming }

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments;

  Status _status = Status.loading;
  final int _limit;
  Selected _selected = Selected.previous;

  AppointmentModel(this._limit) {
    _fetchAppointments(1, true);
  }

  set selected(Selected selected) {
    _selected = selected;
    _status = Status.loading;
    notifyListeners();
    _fetchAppointments(1, _selected == Selected.previous);
  }

  UnmodifiableListView<Appointment> get appointments =>
      UnmodifiableListView(_appointments);

  Selected get selected => _selected;

  Status get status => _status;

  void _fetchAppointments(int page, bool previous) async {
    List<Appointment> newList = await _getList(_limit, page, previous);
    _status = Status.completed;
    _appointments = newList;
    notifyListeners();
  }
}

Future<List<Appointment>> _getList(int limit, int page, bool previous) async {
  http.Response response;
  if (previous) {
    response = await api.fetchPreviousAppointments();
  } else {
    response = await api.fetchUpcomingAppointments();
  }
  if (response.statusCode == 200) {
    return compute(_parseData, response.body);
  } else {
    print(response.statusCode);
    return [];
  }
}

List<Appointment> _parseData(String responseBody) {
  final data = jsonDecode(responseBody);
  return data.map<Appointment>((json) {
    return Appointment.fromJson(json);
  }).toList();
}
