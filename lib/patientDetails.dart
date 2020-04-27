import 'package:Doctor/src/pages/call.dart';
import 'package:permission_handler/permission_handler.dart';

import './patient.dart';

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
            Text('Date: ${patient.dateTime}'),
            if (patient.payment)
              Text('Payment: Done')
            else
              Text('Payment: Pending'),
           // if (patient.payment)
            RaisedButton(
              child: Text('Call'),
              onPressed: () async {
                await _handleCameraAndMic();
                // push video page with given channel name
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                      channelName: patient.serial,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
