import 'dart:convert';


import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './patient.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'VideoChat.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

class PatientDetails extends StatelessWidget {
  final Patient patient;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PatientDetails({this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${patient.pname}'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Card(
              color: Colors.transparent,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text('Name: ${patient.pname}'),
                    Text('Date: ${patient.dateTime}'),
                    if (patient.payment)
                      Text('Payment: Done')
                    else
                      Text('Payment: Pending'),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.only(right: 5),
                      child: Text('Call'),
                      onPressed: () async {
                        await _handleCameraAndMic();

                        String token = await _getPatinetToken();
                        String value = randomAlphaNumeric(10);
                        await _pingFirebase(token,value);
                        //push video page with given channel name
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => VideoChat(
                        //       path: value
                        //     ),
                        //   ),
                        // );
                      },
                    )
                  ],
                ),
              ),
              margin: EdgeInsets.only(left: 5, right: 5),
            ),
            SizedBox(
              height: 20,
            ),
            ...patient.transaction.map((entry) {
              return Card(
                  color: Colors.lightGreen,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                    title: Text(''),
                    subtitle: Text('Transaction Id: ' +
                        entry['transaction_id'].toString()),
                    isThreeLine: true,
                    trailing: Text(
                      'Amount:\n' + entry['amount'].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5, right: 5));
            }).toList(),
            SizedBox(
              height: 10,
            ),
            if (patient.transaction != null &&
                patient.transaction.isNotEmpty &&
                !patient.payment)
              Card(
                color: Colors.transparent,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Verify'),
                        onPressed: () async {
                          await updateTransaction(context);
                        },
                      )
                    ],
                  ),
                ),
                margin: EdgeInsets.only(left: 5, right: 5),
              ),
          ],
        ),
      ),
    );
  }

  Future<String> _getPatinetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    print(patient.phone_number);
    final http.Response response = await http.post(
      'http://192.168.0.104:3000/patient/get/token',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
      body: jsonEncode({'mobile_no': patient.phone_number}),
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  void updateTransaction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.post(
      'http://192.168.0.104:3000/doctor/update/appointment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
      body: jsonEncode({'appointment_id': patient.serial}),
    );

    if (response.statusCode == 200) {
      await _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Payment verified!"),
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Payment not verified!"),
      ));
    }
  }

  void _pingFirebase(String token,String value) async {
    //print(bearer_token);
    var serverToken =
        'AAAAMysQL1A:APA91bE3hyrg1EXgypw03ZL_A42m9ofiJzFdrhWNBXNrVxZX1GjMLyu650Cs-Gf5ek7uGlgNlHDY3Pc3SHHB7ske96wnxKi0dzI6LOadhSUAtdZ15vW8sHXuuBMA6XUpU4RKHvr6DjHQ';
    final http.Response response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode({
        'notification': {'body': value, 'title': 'this is a title'},
        'priority': 'high',
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
        'to': token,
      }),
    );
    print(response.body);
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [
        PermissionGroup.camera,
        PermissionGroup.microphone,
        PermissionGroup.mediaLibrary
      ],
    );
  }
}
