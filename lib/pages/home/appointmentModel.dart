import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:collection';
import 'dart:async';

import '../../models/appointment.dart';
import '../../api.dart' as api;
import './transactionModel.dart';

enum Status { loading, completed, error }

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments = [];
  List<bool> _expanded = [];
  List<TransactionModel> _transactionModels = [];

  Status _status = Status.loading;

  AppointmentModel() {
    _fetchAppointments();
  }

  UnmodifiableListView<Appointment> get appointments => UnmodifiableListView(_appointments);

  UnmodifiableListView<bool> get expanded => UnmodifiableListView(_expanded);

  UnmodifiableListView<TransactionModel> get transactionModels => UnmodifiableListView(_transactionModels);

  Status get status => _status;

  void expand(int index) {
    _expanded[index] = !_expanded[index];
    notifyListeners();
  }

  void _fetchAppointments() async {
    if (_status != Status.loading) {
      _status = Status.loading;
      notifyListeners();
    }
    List<Appointment> newList =
        await _getList();
    _status = Status.completed;
    _appointments = newList;
    _expanded = List.generate(_appointments.length, (index) => false);
    _transactionModels = List.generate(
      _appointments.length,
      (index) => TransactionModel(_appointments[index].id),
    );
    notifyListeners();
  }

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
