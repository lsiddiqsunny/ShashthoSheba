import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/loading.dart';
import '../../providers/doctorProvider.dart';
import '../../providers/scheduleProvider.dart' as schedule;

class DoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return doctorProvider.status == Status.loading
        ? Loading()
        : doctorProvider.doctors.isEmpty
            ? ListTile(
                title: Text(
                  'No Doctors Found',
                  textAlign: TextAlign.center,
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (index, isExpanded) {
                      doctorProvider.expand(index);
                      if (!isExpanded &&
                          doctorProvider.scheduleProviders[index].status ==
                              schedule.Status.loading) {
                        doctorProvider.scheduleProviders[index].fetchSchedules();
                      }
                    },
                    children: doctorProvider.doctors
                        .asMap()
                        .map<int, ExpansionPanel>((index, doctor) {
                          return MapEntry(
                            index,
                            ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  leading: CircleAvatar(),
                                  title: Text(
                                    '${doctorProvider.doctors[index].name}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    '${doctorProvider.doctors[index].designation}, ' +
                                        '${doctorProvider.doctors[index].institution}\n' +
                                        '${doctorProvider.doctors[index].specialization.join(',')}',
                                  ),
                                  isThreeLine: true,
                                );
                              },
                              body: ChangeNotifierProvider.value(
                                value: doctorProvider.scheduleProviders[index],
                                child: Builder(
                                  builder: (context) {
                                    schedule.ScheduleProvider scheduleProvider =
                                        Provider.of<schedule.ScheduleProvider>(
                                            context);
                                    return Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Text(
                                            'Day',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: theme.primaryColor),
                                          ),
                                          title: Text(
                                            'Time',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: theme.primaryColor),
                                          ),
                                          trailing: Text(
                                            'Fee',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: theme.primaryColor),
                                          ),
                                        ),
                                        scheduleProvider.status ==
                                                schedule.Status.loading
                                            ? Loading()
                                            : scheduleProvider.schedules.isEmpty
                                                ? ListTile(
                                                    title: Text(
                                                      'No Schedule Found',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                : Column(
                                                    children: <Widget>[
                                                      ...scheduleProvider.schedules
                                                          .map<ListTile>(
                                                              (value) {
                                                        return ListTile(
                                                          leading: Text(
                                                            value.day,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          title: Text(
                                                            DateFormat.jm()
                                                                    .format(value
                                                                        .start) +
                                                                ' - ' +
                                                                DateFormat.jm()
                                                                    .format(value
                                                                        .end),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          trailing: Text(value
                                                              .fee
                                                              .toString()),
                                                        );
                                                      }).toList(),
                                                      _AddAppointment(index),
                                                    ],
                                                  ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              isExpanded: doctorProvider.expanded[index],
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
              );
  }
}

class _AddAppointment extends StatelessWidget {
  final int doctorIndex;

  _AddAppointment(this.doctorIndex);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    schedule.ScheduleProvider scheduleProvider =
        Provider.of<schedule.ScheduleProvider>(context, listen: false);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return ButtonBar(
      children: <Widget>[
        OutlineButton.icon(
          icon: Icon(Icons.playlist_add),
          borderSide: BorderSide(color: theme.primaryColor),
          label: Text(
            'Appointment',
            style: theme.textTheme.button,
          ),
          onPressed: () async {
            DateTime date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: scheduleProvider.initialDate(),
                lastDate: DateTime.now().add(Duration(days: 30)),
                selectableDayPredicate: (date) {
                  return scheduleProvider.toShow(date.weekday);
                });
            if (date != null) {
              DateTime time = await showDialog(
                context: context,
                builder: (context) {
                  return _SelectTime(date.weekday, scheduleProvider);
                },
              );
              if (time != null) {
                print(date);
                print(time);
                DateTime dateTime = DateTime.parse(
                    DateFormat("yyyy-MM-dd").format(date).toString() +
                        ' ' +
                        DateFormat.Hms().format(time));
                bool success =
                    await doctorProvider.createAppointment(doctorIndex, dateTime);
                if (success) {
                  print('Successfully Created Appointment');
                } else {
                  print('Appointment Creation Failed');
                }
              }
            }
          },
        ),
      ],
    );
  }
}

class _SelectTime extends StatefulWidget {
  final int weekDay;
  final schedule.ScheduleProvider scheduleProvider;

  _SelectTime(this.weekDay, this.scheduleProvider);
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<_SelectTime> {
  int _index = 0;

  _SelectTimeState();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Map<String, DateTime>> times =
        widget.scheduleProvider.times(widget.weekDay);
    return AlertDialog(
      title: Text('Select Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: times
            .asMap()
            .map<int, RadioListTile>((index, time) {
              return MapEntry(
                index,
                RadioListTile<int>(
                  title: Text(
                    DateFormat.jm().format(time['start']) +
                        ' - ' +
                        DateFormat.jm().format(time['end']),
                  ),
                  value: index,
                  groupValue: _index,
                  onChanged: (value) {
                    setState(() {
                      _index = value;
                    });
                  },
                ),
              );
            })
            .values
            .toList(),
      ),
      actions: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: theme.primaryColor),
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        OutlineButton(
          borderSide: BorderSide(color: theme.primaryColor),
          child: Text('Submit'),
          onPressed: () {
            Navigator.pop<DateTime>(context, times[_index]['start']);
          },
        ),
      ],
    );
  }
}
