import 'dart:convert';

import 'package:Doctor/patient.dart';
import 'package:Doctor/patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointmentProvider.dart';
import 'loading.dart';

import 'package:http/http.dart' as http;

class AppointmentList extends StatelessWidget {
  Future<List> getTransaction(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.post(
      'http://192.168.0.103:3000/doctor/get/transaction',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
      body: jsonEncode({'appointment_id': id}),
    );
    //print(response.statusCode );
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body) as List;
      //print(parsed[0]);
      return parsed;
    }
    return null;
  }

  _buildListItem(var entry, BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        onTap: () async {
          //print(data[0]["appointment_detail"][]);
          var transaction =
              await getTransaction(entry["appointment_detail"]['_id']);

          //print(transaction[0]);
          DateTime dateTime = DateTime.parse(
              entry["appointment_detail"]["appointment_date_time"]);

          print(entry["appointment_detail"]['mobile_no']);
          final p = Patient(
              pname: entry["patient_detail"]['name'],
              payment: entry["appointment_detail"]['status'],
              phone_number: entry["patient_detail"]['mobile_no'],
              serial: entry["appointment_detail"]['_id'],
              dateTime: DateFormat("dd/MM/yyyy — HH:mm").format(dateTime),
              transaction: transaction);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetails(patient: p),
            ),
          );
        },
        //title: Text('Serial No:' + entry['serial'].toString()),
        subtitle: Text('Patient Name: ' +
            entry["patient_detail"]['name'] +
            '\n' +
            DateFormat.jm().format(DateTime.parse(
              entry["appointment_detail"]["appointment_date_time"]))),
        isThreeLine: true,
        trailing: Text(
          'Payment:\n' +
              (entry["appointment_detail"]['status']==1 ? 'Done' : 'Pending'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    return appointmentProvider.status == Status.loading
        ? Loading()
        : appointmentProvider.appointments.isEmpty
            ? ListTile(
                title: Text(
                  'No Appointments Today',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) {
                  return _buildListItem(
                      appointmentProvider.appointments[index], ctxt);
                },
                itemCount: appointmentProvider.appointments.length,
              );
  }
}
