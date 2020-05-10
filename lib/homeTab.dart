
import 'package:Doctor/doctor.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'appointmentList.dart';
import 'appointmentProvider.dart';
class HomeTab extends StatefulWidget {
  
  final Doctor doctor;
  HomeTab({this.doctor});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  var data;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (context) => AppointmentProvider(),
            child: Builder(
              builder: (context) {
                return AppointmentList();
              },
            ),
          );
    
  }
}
