import 'package:Doctor/doctor.dart';
import 'package:Doctor/referPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './homeTab.dart';

class TabbedPages extends StatefulWidget {
  static const routeName = '/tabbedpages';
  final Doctor doctor;
  final  entries;
  TabbedPages({this.doctor,this.entries});
  @override
  _TabbedPagesState createState() => _TabbedPagesState(doctor: this.doctor,entries:this.entries);
}

class _TabbedPagesState extends State<TabbedPages>
    with SingleTickerProviderStateMixin {
  final Doctor doctor;
  final  entries;
  _TabbedPagesState({this.doctor,this.entries});
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Today\'s Appointment',
      icon: Icon(Icons.work),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    //print(entries);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              title: Text('Settings'),
            ),
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
          HomeTab(doctor: doctor,data:entries),
        ],
      ),
    );
  }
}
