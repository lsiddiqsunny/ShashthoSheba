import 'package:first_app/patient.dart';
import 'package:first_app/patientDetails.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: <Widget>[
        Text(
          'Today Appointments',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        ...entries.map((entry) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 8, right: 8),
              onTap: () {
                final p =Patient(
                      pname: entry['pname'],
                      payment : entry['payment'],
                      serial : entry['serial'],
                        dateTime: DateFormat("dd/MM/yyyy — HH:mm").format(entry['dateTime']),);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetails(patient:p),
                  ),
                );
              },
              title: Text('Serial No:' + entry['serial'].toString()),
              subtitle: Text('Patient Name: ' +
                  entry['pname'] +
                  '\n' +
                  DateFormat.jm().format(entry['dateTime'])),
              isThreeLine: true,
              trailing: Text(
                'Payment:\n' + (entry['payment'] ? 'Done' : 'Pending'),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList()
      ],
    );
  }
}
