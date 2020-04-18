import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsTab extends StatelessWidget {
  final entries = [
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Shahidul Alam',
    },
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Rafiqul Islam',
    },
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Shirajul Haque',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: <Widget>[
        Text(
          'Recent Appointments',
          style: TextStyle(
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        ...entries.map((entry) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 8, right: 8),
              title: Text('${entries.indexOf(entry) + 1}.' +
                  '\t\t\t\t' +
                  entry['doctor']),
              trailing: Text(
                DateFormat.yMMMMd('en_US').format(entry['dateTime']) +
                    '\n' +
                    DateFormat.jm().format(entry['dateTime']),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList()
      ],
    );
  }
}
