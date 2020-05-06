import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'dart:collection';
import 'dart:async';

import '../models/doctor.dart';
import '../networking/api.dart' as api;
import './scheduleProvider.dart';

enum Status { loading, completed, error }
enum Filter { name, hospital, speciality }

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  List<bool> _expanded = [];
  List<ScheduleProvider> _scheduleProviders = [];

  Status _status = Status.loading;
  final int _perPage;
  Filter _filter = Filter.name;

  TextEditingController searchController = TextEditingController();
  StreamController<String> streamController = StreamController();

  @override
  void dispose() {
    searchController.dispose();
    streamController.close();
    super.dispose();
  }

  DoctorProvider(this._perPage) {
    //this ensures that fetchDoctors is called only when the user has stopped typing
    streamController.stream
        .debounce(Duration(milliseconds: 400))
        .listen((value) {
      if (value == '') {
        _fetchDoctors(1);
      } else {
        _fetchDoctors(1, filter: _filter, value: value);
      }
    });
    _fetchDoctors(1);
  }

  UnmodifiableListView<Doctor> get doctors => UnmodifiableListView(_doctors);

  UnmodifiableListView<bool> get expanded => UnmodifiableListView(_expanded);

  UnmodifiableListView<ScheduleProvider> get scheduleProviders =>
      UnmodifiableListView(_scheduleProviders);

  Status get status => _status;

  Filter get filter => _filter;

  set filter(Filter filter) {
    _filter = filter;
    if (searchController.text == '') {
      notifyListeners();
    } else {
      _fetchDoctors(1, filter: _filter, value: searchController.text);
    }
  }

  void expand(int index) {
    _expanded[index] = !_expanded[index];
    notifyListeners();
  }

  void _fetchDoctors(int page, {Filter filter, String value}) async {
    if (_status != Status.loading) {
      _status = Status.loading;
      notifyListeners();
    }
    List<Doctor> newList =
        await _getList(_perPage, page, filter: filter, value: value);
    _status = Status.completed;
    _doctors = newList;
    _expanded = List.generate(_doctors.length, (index) => false);
    _scheduleProviders = List.generate(
      _doctors.length,
      (index) => ScheduleProvider(_doctors[index].mobileNo),
    );
    notifyListeners();
  }

  Future<bool> createAppointment(int index, DateTime appointmentTime) async {
    try {
      await api.createAppointment(_doctors[index].mobileNo, appointmentTime);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

Future<List<Doctor>> _getList(int perPage, int page,
    {Filter filter, String value}) async {
  try {
    dynamic data;
    if (filter == null) {
      data = await api.fetchDoctors(perPage, page);
    } else if (filter == Filter.name) {
      data = await api.fetchDoctorsByName(perPage, page, value);
    } else if (filter == Filter.hospital) {
      data = await api.fetchDoctorsByHospital(perPage, page, value);
    } else {
      data = await api.fetchDoctorsBySpeciality(perPage, page, value);
    }
    return data['docs'].map<Doctor>((json) {
      return Doctor.fromJson(json);
    }).toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}
