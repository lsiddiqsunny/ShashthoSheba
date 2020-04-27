import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../models/doctor.dart';
import '../../api.dart' as api;

enum Status { loading, completed, error }
enum Filter { name, hospital, speciality }

class DoctorModel extends ChangeNotifier {
  List<Doctor> _doctors = [];
  Status status;
  final int limit;

  DoctorModel(this.limit) {
    fetchDoctors(1);
  }

  List<Doctor> get doctors => _doctors;

  void fetchDoctors(int page, {Filter filter, String value}) async {
    status = Status.loading;
    notifyListeners();
    List<Doctor> newList = await _getList(limit, page, filter: filter, value: value);
    status = Status.completed;
    if (newList != _doctors) {
      _doctors = newList;
      notifyListeners();
    }
  }
}

Future<List<Doctor>> _getList(int limit, int page, {Filter filter, String value}) async {
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
