import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatelessWidget {
  final entries = [
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Shahidul',
      'payment': true,
    },
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Rafiqul',
      'payment': false,
    },
    {
      'dateTime': DateTime.now(),
      'doctor': 'Dr.Shirajul',
      'payment': true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: <Widget>[
        Text(
          'Upcoming',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        ...entries.map((entry) {
          return Card(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 8, right: 8),
              title: Text(DateFormat.yMMMMd('en_US').format(entry['dateTime'])),
              subtitle: Text(DateFormat.jm().format(entry['dateTime']) +
                  '\n' +
                  entry['doctor']),
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
