import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './ongoingCallPage.dart';

class IncomingCall extends StatefulWidget {
  static String routeName = '/incomingCall';

  @override
  _IncomingCallState createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  String status = '';

  void _acceptCall(BuildContext context) async {
    setState(() {
      status = 'Connecting';
    });
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.mediaLibrary,
    ].request();
    print(statuses[Permission.camera]);
    print(statuses[Permission.microphone]);
    print(statuses[Permission.mediaLibrary]);
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    String token = data['token'];
    Navigator.pushNamed(context, OngoingCall.routeName,
        arguments: token);
  }

  void _rejectCall(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    String doctorName = data['doctor_name'];
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircleAvatar(
                minRadius: 100,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              doctorName,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor),
            ),
            Text(
              'is calling',
              style: TextStyle(fontSize: 20, color: theme.primaryColor),
            ),
            Text(
              status,
              style: TextStyle(fontSize: 20, color: theme.primaryColor),
            ),
            Expanded(
              child: SizedBox(),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor,
                    ),
                    child: FittedBox(
                      child: IconButton(
                        icon: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        onPressed: () => _acceptCall(context),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: FittedBox(
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => _rejectCall(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
