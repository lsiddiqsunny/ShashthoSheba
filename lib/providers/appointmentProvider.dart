import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/appointment.dart';
import '../networking/api.dart' as api;

enum Status { loading, completed, error }
enum Selected { previous, upcoming }

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments;

  Status _status = Status.loading;
  final int _limit;
  Selected _selected = Selected.previous;

  AppointmentProvider(this._limit) {
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

  String getImageURL(int index) {
    return api.baseUrl + _appointments[index].imageURL;
  }

  Future<bool> saveImage(int index) async {
    try {
      var response = await get(getImageURL(index));
      var documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File(join(documentDirectory.path, 'imagetest.png'));
      file.writeAsBytesSync(response.bodyBytes);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> cancelAppointment(Appointment appointment) async {
    try {
      await api.cancelAppointment(appointment.id);
      _appointments.remove(appointment);
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

Future<List<Appointment>> _getList(int limit, int page, bool previous) async {
  try {
    dynamic data;
    if (previous) {
      data = await api.fetchPreviousAppointments();
    } else {
      data = await api.fetchUpcomingAppointments();
    }
    return data.map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}
