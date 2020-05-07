import 'dart:convert';

import 'package:Doctor/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './patient.dart';
import './patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class FutureTab extends StatelessWidget {
  
  final Doctor doctor;
  final data;
  FutureTab({this.doctor, this.data});
  
  Future<List> getTransaction(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token+= prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.post(
      'http://192.168.0.101:3000/doctor/get/transaction',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : bearer_token,
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
          var transaction = await getTransaction(entry["appointment_detail"]['_id']);
          
          //print(transaction[0]);
          
          final p = Patient(
            pname: entry["patient_detail"]['name'],
            payment: entry["appointment_detail"]['status'],
            serial: entry["appointment_detail"]['_id'],
            dateTime: DateFormat("dd/MM/yyyy — HH:mm")
                .format(DateTime.now()),
                transaction: transaction
          );
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
            DateFormat.jm()
                .format(DateTime.now())),
        isThreeLine: true,
        trailing: Text(
          'Payment:\n' +
              (entry["appointment_detail"]['status'] ? 'Done' : 'Pending'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctxt, int index) {
        return _buildListItem(data[index], ctxt);
      },
      itemCount: data.length,
    );
  }
}
