import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import './doctorModel.dart';
import './scheduleModel.dart' as schedule;

class DoctorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DoctorModel doctorModel = Provider.of<DoctorModel>(context);
    return doctorModel.status == Status.loading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(),
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  doctorModel.expand(index);
                },
                children: doctorModel.doctors
                    .asMap()
                    .map<int, ExpansionPanel>((index, doctor) {
                      return MapEntry(
                        index,
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              leading: CircleAvatar(),
                              title: Text(
                                '${doctorModel.doctors[index].name}',
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                '${doctorModel.doctors[index].designation}, ' +
                                    '${doctorModel.doctors[index].institution}\n' +
                                    '${doctorModel.doctors[index].specialization.join(',')}',
                              ),
                              isThreeLine: true,
                            );
                          },
                          body: ChangeNotifierProvider(
                            create: (context) => schedule.ScheduleModel(
                              doctorModel.doctors[index].mobileNo,
                            ),
                            child: Builder(
                              builder: (context) {
                                schedule.ScheduleModel scheduleModel =
                                    Provider.of<schedule.ScheduleModel>(
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
                                    ...scheduleModel.schedules
                                        .map<ListTile>((value) {
                                      return ListTile(
                                        leading: Text(
                                          value.day,
                                          textAlign: TextAlign.center,
                                        ),
                                        title: Text(
                                          DateFormat.jm().format(value.start) +
                                              ' - ' +
                                              DateFormat.jm().format(value.end),
                                          textAlign: TextAlign.center,
                                        ),
                                        trailing: Text(value.fee.toString()),
                                      );
                                    }).toList(),
                                    _AddAppointment(index),
                                  ],
                                );
                              },
                            ),
                          ),
                          isExpanded: doctorModel.expanded[index],
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
  int doctorIndex;

  _AddAppointment(this.doctorIndex);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    schedule.ScheduleModel scheduleModel =
        Provider.of<schedule.ScheduleModel>(context, listen: false);
    DoctorModel doctorModel = Provider.of<DoctorModel>(context, listen: false);
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
                initialDate: scheduleModel.initialDate(),
                lastDate: DateTime.now().add(Duration(days: 30)),
                selectableDayPredicate: (date) {
                  return scheduleModel.toShow(date.weekday);
                });
            if (date != null) {
              DateTime time = await showDialog(
                context: context,
                builder: (context) {
                  return _SelectTime(date.weekday, scheduleModel);
                },
              );
              if (time != null) {
                print(date);
                print(time);
                DateTime dateTime = DateTime.parse(
                    DateFormat("yyyy-MM-dd").format(date).toString() +
                        ' ' +
                        DateFormat.Hms().format(time));
                int statusCode = await doctorModel.createAppointment(doctorIndex, dateTime);
                if(statusCode == 200) {
                  print('success');
                } else {
                  print(statusCode);
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
  final schedule.ScheduleModel scheduleModel;

  _SelectTime(this.weekDay, this.scheduleModel);
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
        widget.scheduleModel.times(widget.weekDay);
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
