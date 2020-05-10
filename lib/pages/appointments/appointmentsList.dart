import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/loading.dart';
import '../../widgets/dialogs.dart';
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
                        style: theme.textTheme.subtitle1,
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
                              style: theme.textTheme.headline6,
                            ),
                            TextSpan(
                              text: '\nSerial: ' +
                                  appointmentProvider
                                      .appointments[index].serialNo
                                      .toString() +
                                  '\nwith ' +
                                  appointmentProvider
                                      .appointments[index].doctorName,
                              style: theme.textTheme.caption,
                            ),
                          ],
                          style: theme.textTheme.caption,
                        ),
                      ),
                      trailing: appointmentProvider.selected ==
                              Selected.previous
                          ? IconButton(
                              icon: Icon(Icons.image),
                              color: theme.primaryColor,
                              onPressed: appointmentProvider
                                          .appointments[index].imageURL ==
                                      null
                                  ? () {}
                                  : () => _showImageDialog(
                                      context, appointmentProvider, index),
                            )
                          : OutlineButton(
                              child: Text(
                                'Cancel',
                                style: theme.textTheme.button,
                              ),
                              borderSide: BorderSide(color: theme.primaryColor),
                              onPressed: () async {
                                bool cancel = await confirmationDialog(context,
                                    'If you press accept then your appointment will be canceled');
                                if (cancel) {
                                  bool success = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      appointmentProvider
                                          .cancelAppointment(appointmentProvider
                                              .appointments[index])
                                          .then(
                                            (result) => Navigator.pop<bool>(
                                                context, result),
                                          );
                                      return LoadingDialog(
                                          message: 'Please Wait');
                                    },
                                  );
                                  if (success) {
                                    print('Appointment Canceled Successfully');
                                    await successDialog(context,
                                        'Appointment Canceled Successfully');
                                  } else {
                                    print('Appointment Cancelation Failed');
                                    await failureDialog(context,
                                        'Appointment Cancelation Failed');
                                  }
                                }
                              },
                            ),
                    );
                  },
                ),
              );
  }
}

void _showImageDialog(BuildContext context,
    AppointmentProvider appointmentProvider, int index) async {
  ThemeData theme = Theme.of(context);
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Image.network(
          appointmentProvider.getImageURL(index),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.file_download,
              color: theme.primaryColor,
            ),
            label: Text('Save', style: theme.textTheme.button),
            onPressed: () async {
              bool success = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  appointmentProvider.saveImage(index).then(
                        (result) => Navigator.pop<bool>(context, result),
                      );
                  return LoadingDialog(message: 'Saving');
                },
              );
              if (success) {
                await successDialog(context, 'Image Saved Successfully');
              } else {
                await failureDialog(context, 'Image Could Not Be Saved');
              }
            },
          ),
        ],
      );
    },
  );
}
