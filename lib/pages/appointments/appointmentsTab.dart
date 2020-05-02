import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './selectionBar.dart';
import './appointmentsList.dart';
import './appointmentModel.dart';

class AppointmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => AppointmentModel(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Show Appointments',
                style: theme.textTheme.title,
              ),
            ),
          ),
          SelectionBar(),
          AppointmentsList(),
        ],
      ),
    );
  }
}
