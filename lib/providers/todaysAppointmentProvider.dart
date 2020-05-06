import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'dart:async';

import '../models/appointment.dart';
import '../networking/api.dart' as api;
import './transactionProvider.dart';

enum Status { loading, completed, error }

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];
  List<bool> _expanded = [];
  List<TransactionProvider> _transactionProviders = [];

  Status _status = Status.loading;

  AppointmentProvider() {
    _fetchAppointments();
  }

  UnmodifiableListView<Appointment> get appointments =>
      UnmodifiableListView(_appointments);

  UnmodifiableListView<bool> get expanded => UnmodifiableListView(_expanded);

  UnmodifiableListView<TransactionProvider> get transactionProviders =>
      UnmodifiableListView(_transactionProviders);

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
    List<Appointment> newList = await _getList();
    _status = Status.completed;
    _appointments = newList;
    _expanded = List.generate(_appointments.length, (index) => false);
    _transactionProviders = List.generate(
      _appointments.length,
      (index) => TransactionProvider(_appointments[index].id),
    );
    notifyListeners();
  }
}

Future<List<Appointment>> _getList() async {
  try {
    final data = await api.fetchTodaysAppointments();
    return data.map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}
