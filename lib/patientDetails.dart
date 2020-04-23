import 'package:first_app/patient.dart';
import 'package:first_app/src/pages/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PatientDetails extends StatelessWidget {
  final Patient patient;

  PatientDetails({this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.pname}'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
                height: 54.0,
                padding: EdgeInsets.all(12.0),
                child: Text('Patient details:',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            Text('Name: ${patient.pname}'),
            Text('Serial: ${patient.serial}'),
            Text('Date: ${patient.dateTime}'),
            if (patient.payment)
              Text('Payment: Done')
            else
              Text('Payment: Pending'),
            RaisedButton(
              child: Text('Call'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IndexPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
