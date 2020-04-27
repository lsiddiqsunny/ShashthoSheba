import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './models/patient.dart';
import './models/transaction.dart';

final _baseUrl = 'http://192.168.0.105';

Future<int> patientRegister(Patient patient) async {
  http.Response response =
      await _post('/patient/post/register', false, patient);
  return response.statusCode;
}

Future<http.Response> patientLogin(Map<String, String> body) async {
  http.Response response = await _post('/patient/post/login', false, body);
  return response;
}

Future<http.Response> fetchTodaysAppointments() async {
  http.Response response = await _get('/patient/get/today/appointment/', true);
  return response;
}

Future<int> addTransaction(Transaction transaction) async {
  http.Response response =
      await _post('/patient/add/transaction', true, transaction);
  return response.statusCode;
}

Future<http.Response> fetchTransactions(Map<String, String> body) async {
  http.Response response = await _post('/patient/get/transaction/', true, body);
  return response;
}

Future<http.Response> fetchDoctors(int limit, int page) async {
  http.Response response = await _get(
      '/doctor/list/all/' + limit.toString() + '/' + page.toString(), false);
  return response;
}

Future<http.Response> fetchDoctorsByName(
    int limit, int page, String name) async {
  http.Response response = await _get(
    '/doctor/search/name/' +
        name +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
  return response;
}

Future<http.Response> fetchDoctorsByHospital(
    int limit, int page, String hospital) async {
  http.Response response = await _get(
    '/doctor/search/hospital_name/' +
        hospital +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
  return response;
}

Future<http.Response> fetchDoctorsBySpeciality(
    int limit, int page, String speciality) async {
  http.Response response = await _get(
    '/doctor/search/specialization/' +
        speciality +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
  return response;
}

Future<http.Response> _get(String url, bool authorization) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  if (authorization) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headers.addAll({
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    });
  }
  return await http.get(
    _baseUrl + url,
    headers: headers,
  );
}

Future<http.Response> _post(String url, bool authorization, var object) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  if (authorization) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headers.addAll({
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    });
  }
  return await http.post(
    _baseUrl + url,
    headers: headers,
    body: jsonEncode(object),
  );
}
