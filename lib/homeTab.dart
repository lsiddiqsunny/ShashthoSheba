import 'package:Doctor/doctor.dart';

import './patient.dart';
import './patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatelessWidget {
  final entries = [
    {
      'dateTime': DateTime.now(),
      'pname': 'Ahsanul Kabir',
      'payment': true,
      'serial': 2,
    },
    {
      'dateTime': DateTime.now(),
      'pname': 'Waqar Hassan Khan',
      'payment': false,
      'serial': 1,
    },
    {
      'dateTime': DateTime.now(),
      'pname': 'Afsara Benazir',
      'payment': true,
      'serial': 4
    }
  ];
  final Doctor doctor;
  final data;
  HomeTab({this.doctor, this.data});
  
  _buildListItem(var entry, BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        onTap: () {
          //print(data[0]["appointment_detail"][]);
          final p = Patient(
            pname: entry["patient_detail"]['name'],
            payment: entry["appointment_detail"]['status'],
            serial: entry["appointment_detail"]['_id'],
            dateTime: DateFormat("dd/MM/yyyy — HH:mm")
                .format(DateTime.now()),
          );
          Navigator.push(
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
