
import 'package:Doctor/doctor.dart';
import 'package:Doctor/futureAppoinmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


import 'futureAppointmentList.dart';
class FutureTab extends StatefulWidget {
  
  final Doctor doctor;
  FutureTab({this.doctor});

  @override
  _FutureTabState createState() => _FutureTabState();
}

class _FutureTabState extends State<FutureTab> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (context) => FutureAppointmentProvider(),
            child: Builder(
              builder: (context) {
                return FutureAppointmentList();
              },
            ),
          );
    
  }
}
