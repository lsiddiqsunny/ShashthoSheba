import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/loading.dart';
import './appointmentModel.dart';

class AppointmentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppointmentModel appointmentModel = Provider.of<AppointmentModel>(context);
    return appointmentModel.status == Status.loading
        ? Loading()
        : appointmentModel.appointments.isEmpty
            ? ListTile(
                title: Text(
                  appointmentModel.selected == Selected.previous
                      ? 'No Appoinments Yet'
                      : 'No upcoming Appointments',
                  textAlign: TextAlign.center,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: appointmentModel.appointments.length,
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
                        textAlign: appointmentModel.selected == Selected.previous ? TextAlign.center : TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  appointmentModel.selected == Selected.previous
                                      ? DateFormat.yMMMMd('en_US')
                                          .add_jm()
                                          .format(appointmentModel
                                              .appointments[index].dateTime)
                                      : DateFormat("EEEE, MMMM d, yyyy \nh:mm a")
                                          .format(appointmentModel
                                              .appointments[index].dateTime),
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '\nwith ' +
                                  appointmentModel
                                      .appointments[index].doctorName,
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: appointmentModel.selected == Selected.previous
                          ? IconButton(
                              icon: Icon(Icons.image),
                              color: theme.primaryColor,
                              onPressed: () {},
                            )
                          : null,
                    );
                  },
                ),
              );
  }
}
