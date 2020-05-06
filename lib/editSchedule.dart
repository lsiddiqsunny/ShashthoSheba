import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editSchedulePage extends StatefulWidget {
  static const routeName = '/schedule';
  final schedule;
  editSchedulePage({this.schedule});
  @override
  _editSchedulePageState createState() =>
      _editSchedulePageState(schedule: schedule);
}

class _editSchedulePageState extends State<editSchedulePage> {
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final schedule;
  _editSchedulePageState({this.schedule});
  int getDay(String day) {
    if (day == "Monday") {
      return 1;
    }
    if (day == "Tuesday") {
      return 2;
    }
    if (day == "Wednesday") {
      return 3;
    }
    if (day == "Thursday") {
      return 4;
    }
    if (day == "Friday") {
      return 5;
    }
    if (day == "Saturday") {
      return 6;
    }
    if (day == "Sunday") {
      return 7;
    }
    return -1;
  }
String getDayString(int num) {
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
    }
    else {
      return "";
    }
  }
  final _formKey = GlobalKey<FormState>();
  void submitAction(BuildContext context) async {
    // Patient patient = Patient(
    //   name: _name.text,
    //   mobileNo: _mobileNo.text,
    //   dob: _selectedDate,
    //   sex: _sex,
    //   password: _pass.text,
    // );
    // print(DateFormat.yMMMMd().format(patient.dob));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    final http.Response response = await http.post(
      'http://192.168.0.104:3000/doctor/edit/schedule',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
      body: jsonEncode({
        'id': schedule['_id'],
        'doc_mobile_no': schedule['doc_mobile_no'],
        'time_start': '2020-04-28 '+startHour+':'+startTime+':00',
        'time_end': '2020-04-28 '+endHour+':'+endTime+':00',
        'day': getDay(selectedDay),
        'fee': double.parse(_fee.text)
      }),
      // body: jsonEncode({'name': _name.text, 'password': _pass.text, "email": _email.text, "institution": _institution.text,"designation": _designation.text,"mobile_no": _mobileNo.text, "reg_number" : _reg_number.text}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Schedule successful!"),
      ));
      Navigator.pop(context);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to register patient');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Schedule editing unsuccessful!"),
      ));
    }
  }
  String selectedDay = 'Monday';
  String startHour = '00';
  String startTime = '00';
  String endHour = '00';
  String endTime = '00';
  @override
  void initState() {
    super.initState();
    selectedDay = getDayString(schedule["day"]);
    startHour = DateFormat("HH").format(DateTime.parse(schedule["time_start"]));
    startTime = DateFormat("mm").format(DateTime.parse(schedule["time_start"]));

    endHour = DateFormat("HH").format(DateTime.parse(schedule["time_end"]));
    endTime = DateFormat("mm").format(DateTime.parse(schedule["time_end"]));
  }
  
  Widget daySelector() {
    return DropdownButton<String>(
      value: selectedDay,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedDay = newValue;
        });
      },
      items: <String>[
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  
  Widget startHourSelector() {
    return DropdownButton<String>(
      value: startHour,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          startHour = newValue;
        });
      },
      items: <String>[
        '00',
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22',
        '23'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget startTimeSelector() {
    return DropdownButton<String>(
      value: startTime,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          startTime = newValue;
        });
      },
      items: <String>[
        '00',
        '05',
        '10',
        '15',
        '20',
        '25',
        '30',
        '35',
        '40',
        '45',
        '50',
        '55'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  
  Widget endHourSelector() {
    return DropdownButton<String>(
      value: endHour,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          endHour = newValue;
        });
      },
      items: <String>[
        '00',
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22',
        '23'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  
  Widget endTimeSelector() {
    return DropdownButton<String>(
      value: endTime,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          endTime = newValue;
        });
      },
      items: <String>[
        '00',
        '05',
        '10',
        '15',
        '20',
        '25',
        '30',
        '35',
        '40',
        '45',
        '50',
        '55'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  final _fee = TextEditingController();
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
            Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(35),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Add a schedule',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Select a day:'),
                                  daySelector(),
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Select a start time:'),
                                  startHourSelector(),
                                  Text(':'),
                                  startTimeSelector(),
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Select an end time:'),
                                  endHourSelector(),
                                  Text(':'),
                                  endTimeSelector(),
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _fee,
                              decoration: InputDecoration(
                                labelText: 'Fee',
                                hasFloatingPlaceholder: true,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter fee';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    submitAction(context);
                                  }
                                },
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(left: 25, right: 25),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
