import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/patient.dart';
import '../models/transaction.dart';
import './customException.dart';

final _baseUrl = 'http://192.168.0.105';

dynamic patientRegister(Patient patient) async {
  return await _post('/patient/post/register', false, patient);
}

dynamic patientLogin(Map<String, String> body) async {
  return await _post('/patient/post/login', false, body);
}

dynamic patientDetails() async {
  return await _get('/patient/get/details/', true);
}

dynamic patientLogOut() async {
  return await _post('/patient/post/logout/', true, {});
}

dynamic sendToken(String patientId, String token) async {
  return await _post('/patient/set/token/', true, {
    'id': patientId,
    'registration_token': token,
  });
}

dynamic fetchTodaysAppointments() async {
  return await _get('/patient/get/today/appointment/', true);
}

dynamic fetchPreviousAppointments() async {
  return await _get('/patient/get/past/appointment/', true);
}

dynamic fetchUpcomingAppointments() async {
  return await _get('/patient/get/future/appointment/', true);
}

dynamic createAppointment(String mobileNo, DateTime dateTime) async {
  return await _post('/patient/post/appointment', true, {
    'doc_mobile_no': mobileNo,
    'appointment_date_time': dateTime.toString(),
  });
}

dynamic cancelAppointment(String appointmentId) async {
  return await _post('/patient/cancel/appointment', true, {
    'id': appointmentId,
  });
}

dynamic addTransaction(Transaction transaction) async {
  return await _post('/patient/add/transaction', true, transaction);
}

dynamic fetchTransactions(String appointmentId) async {
  return await _post(
      '/patient/get/transaction/', true, {'appointment_id': appointmentId});
}

dynamic fetchDoctors(int limit, int page) async {
  return await _get(
      '/doctor/list/all/' + limit.toString() + '/' + page.toString(), false);
}

dynamic fetchSchedules(String mobileNo) async {
  return await _post('/patient/get/schedule/', true, {'mobile_no': mobileNo});
}

dynamic fetchDoctorsByName(int limit, int page, String name) async {
  return await _get(
    '/doctor/search/name/' +
        name +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
}

dynamic fetchDoctorsByHospital(int limit, int page, String hospital) async {
  return await _get(
    '/doctor/search/hospital_name/' +
        hospital +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
}

dynamic fetchDoctorsBySpeciality(int limit, int page, String speciality) async {
  return await _get(
    '/doctor/search/specialization/' +
        speciality +
        '/' +
        limit.toString() +
        '/' +
        page.toString(),
    false,
  );
}

dynamic _get(String url, bool authorization) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  if (authorization) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headers.addAll({
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    });
  }
  return _response(await http.get(
    _baseUrl + url,
    headers: headers,
  ));
}

dynamic _post(String url, bool authorization, var object) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  if (authorization) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    headers.addAll({
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    });
  }
  return _response(await http.post(
    _baseUrl + url,
    headers: headers,
    body: jsonEncode(object),
  ));
}

dynamic _response(http.Response response) {
  switch (response.statusCode) {
    case 200:
      print(response.body);
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
      break;
    case 400:
      throw BadRequestException(response.body);
      break;
    case 401:
      throw UnauthorisedException(response.body);
      break;
    case 403:
      throw ForbiddenException(response.body);
      break;
    case 404:
      throw DataNotFoundException(response.body);
      break;
    case 500:
      throw InternalServerException(response.body);
      break;
    default:
      throw FetchDataException(
          "Error occured while communicating with server with status code: ${response.statusCode}");
  }
}
