import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/todaysAppointmentProvider.dart';
import './appointmentList.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              'Appointments Today:',
              style: theme.textTheme.title,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AppointmentProvider(),
            child: Builder(
              builder: (context) {
                return AppointmentList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
