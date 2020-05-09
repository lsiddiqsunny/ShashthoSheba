import 'dart:convert';

import 'package:Doctor/doctor.dart';
import 'package:Doctor/futureTab.dart';
import 'package:Doctor/referPage.dart';
import 'package:Doctor/schedulePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './homeTab.dart';
import 'package:http/http.dart' as http;

class TabbedPages extends StatefulWidget {
  static const routeName = '/tabbedpages';
  final Doctor doctor;

  TabbedPages({this.doctor});
  @override
  _TabbedPagesState createState() => _TabbedPagesState(
      doctor: this.doctor);
}

class _TabbedPagesState extends State<TabbedPages>
    with SingleTickerProviderStateMixin {
  final Doctor doctor;

  _TabbedPagesState({this.doctor});
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Today\'s Appointment',
      icon: Icon(Icons.work),
    ),
    Tab(
      text: 'Tomorrow\'s Appointment',
      icon: Icon(Icons.access_alarm),
    ),
  ];

  TabController _tabController;
  
  @override
  void initState()  {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List> getSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    //print(bearer_token);
    final http.Response response = await http.get(
      'http://192.168.0.103:3000/doctor/get/schedule',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
    );
    //print(response.statusCode );
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body) as List;
      //print(parsed[0]);
      return parsed;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shashtho Sheba"),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    minRadius: 45,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    doctor.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: Icon(Icons.add),
                title: Text('Refer'),
                onTap: () {
                  Navigator.pushNamed(context, ReferPage.routeName);
                }),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Schedule'),
                onTap: () async {
                  var schedule = await getSchedule();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchedulePage(
                        schedule: schedule,
                      ),
                    ),
                  );
                }),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('jwt', "");
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(doctor: doctor, ),
          FutureTab(doctor: doctor,),
        ],
      ),
    );
  }
}
