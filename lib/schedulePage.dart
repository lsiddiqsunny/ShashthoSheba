import 'package:Doctor/addSchedule.dart';
import 'package:Doctor/editSchedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  static const routeName = '/schedule';
  final schedule;
  SchedulePage({this.schedule});
  @override
  _SchedulePageState createState() => _SchedulePageState(schedule: schedule);
}

class _SchedulePageState extends State<SchedulePage> {
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final schedule;
  _SchedulePageState({this.schedule});
  String getDay(int num) {
    if (num == 1) {
      return "Monday";
    } else if (num == 2) {
      return "Tuesday";
    } else if (num == 3) {
      return "Wednesday";
    } else if (num == 4) {
      return "Thursday";
    } else if (num == 5) {
      return "Friday";
    } else if (num == 6) {
      return "Saturday";
    } else if (num == 7) {
      return "Sunday";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Shashtho Sheba"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Card(
              color: Colors.transparent,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Schedule Details',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              margin: EdgeInsets.only(left: 5, right: 5),
            ),
            SizedBox(
              height: 20,
            ),
            ...schedule.map((entry) {
              return ListView(shrinkWrap: true, children: <Widget>[
                Card(
                    //color: Colors.lightGreen,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 8, right: 8),
                      title: Text('Day: ' + getDay(entry["day"])),
                      subtitle: Text('Start Time: ' +
                          DateFormat("HH:mm")
                              .format(DateTime.parse(entry["time_start"])) +
                          '\n' +
                          'End Time: ' +
                          DateFormat("HH:mm")
                              .format(DateTime.parse(entry["time_end"])) +
                          '\n' +
                          'Fee: ' +
                          entry['fee'].toString()),
                      isThreeLine: true,
                      trailing: RaisedButton(
                        color: Colors.blue,
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Edit'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    editSchedulePage(schedule: entry)),
                          );
                        },
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5, right: 5)),
                SizedBox(
                  height: 10,
                ),
              ]);
            }).toList(),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.transparent,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blue,
                      padding: EdgeInsets.only(right: 5),
                      child: Text('Add new schedule'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addSchedulePage()),
                        );
                      },
                    )
                  ],
                ),
              ),
              margin: EdgeInsets.only(left: 5, right: 5),
            ),
          ],
        ),
      ),
    );
  }
}
