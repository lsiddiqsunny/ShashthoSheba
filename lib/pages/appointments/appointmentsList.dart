import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/loading.dart';
import '../../providers/appointmentProvider.dart';

class AppointmentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    return appointmentProvider.status == Status.loading
        ? Loading()
        : appointmentProvider.appointments.isEmpty
            ? ListTile(
                title: Text(
                  appointmentProvider.selected == Selected.previous
                      ? 'No Appoinments Yet'
                      : 'No upcoming Appointments',
                  textAlign: TextAlign.center,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: appointmentProvider.appointments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        (index + 1).toString() + '.',
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: RichText(
                        textAlign:
                            appointmentProvider.selected == Selected.previous
                                ? TextAlign.center
                                : TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: appointmentProvider.selected ==
                                      Selected.previous
                                  ? DateFormat.yMMMMd('en_US').add_jm().format(
                                      appointmentProvider
                                          .appointments[index].dateTime)
                                  : DateFormat("EEEE,\nMMMM d, yyyy \nh:mm a")
                                      .format(appointmentProvider
                                          .appointments[index].dateTime),
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '\nwith ' +
                                  appointmentProvider
                                      .appointments[index].doctorName,
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: theme.textTheme.body1,
                        ),
                      ),
                      trailing: appointmentProvider.selected ==
                              Selected.previous
                          ? IconButton(
                              icon: Icon(Icons.image),
                              color: theme.primaryColor,
                              onPressed: () {},
                            )
                          : OutlineButton(
                              child: Text(
                                'Cancel',
                                style: theme.textTheme.button,
                              ),
                              borderSide: BorderSide(color: theme.primaryColor),
                              onPressed: () async {
                                bool cancel =
                                    await _confirmationDialog(context);
                                if (cancel &&
                                    await appointmentProvider.cancelAppointment(
                                        appointmentProvider
                                            .appointments[index])) {
                                  //Implement UI notification
                                  print('Appointment Canceled Successfully');
                                }
                              },
                            ),
                    );
                  },
                ),
              );
  }
}

Future<bool> _confirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are You Sure?'),
        content:
            Text('If you press accept then your appointment will be canceled'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop<bool>(context, false);
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop<bool>(context, true);
            },
            child: Text('Accept'),
          ),
        ],
      );
    },
  );
}
