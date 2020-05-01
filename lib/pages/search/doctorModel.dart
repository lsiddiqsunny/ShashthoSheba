import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'dart:convert';
import 'dart:collection';
import 'dart:async';

import '../../models/doctor.dart';
import '../../api.dart' as api;

enum Status { loading, completed, error }
enum Filter { name, hospital, speciality }

class DoctorModel extends ChangeNotifier {
  List<Doctor> _doctors = [];
  List<bool> _expanded = [];

  Status _status;
  final int _limit;
  Filter _filter = Filter.name;

  TextEditingController searchController = TextEditingController();
  StreamController<String> streamController = StreamController();

  @override
  void dispose() {
    searchController.dispose();
    streamController.close();
    super.dispose();
  }

  DoctorModel(this._limit) {
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

  List<Doctor> get doctors => UnmodifiableListView(_doctors);

  List<bool> get expanded => UnmodifiableListView(_expanded);

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
    _status = Status.loading;
    notifyListeners();
    List<Doctor> newList =
        await _getList(_limit, page, filter: filter, value: value);
    _status = Status.completed;
    _doctors = newList;
    _expanded = List.generate(_doctors.length, (index) => false);
    notifyListeners();
  }

  Future<int> createAppointment(int index, DateTime appointmentTime) async {
    return await api.createAppointment({
      'doc_mobile_no': _doctors[index].mobileNo,
      'appointment_date_time': appointmentTime.toString(),
    });
  }
}

Future<List<Doctor>> _getList(int limit, int page,
    {Filter filter, String value}) async {
  http.Response response;
  if (filter == null) {
    response = await api.fetchDoctors(limit, page);
  } else if (filter == Filter.name) {
    response = await api.fetchDoctorsByName(limit, page, value);
  } else if (filter == Filter.hospital) {
    response = await api.fetchDoctorsByHospital(limit, page, value);
  } else {
    response = await api.fetchDoctorsBySpeciality(limit, page, value);
  }
  if (response.statusCode == 200) {
    return compute(_parseData, response.body);
  } else {
    print(response.statusCode);
    return [];
  }
}

List<Doctor> _parseData(String responseBody) {
  final data = jsonDecode(responseBody);
  return data['docs'].map<Doctor>((json) {
    return Doctor.fromJson(json);
  }).toList();
}
