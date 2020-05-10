import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/loading.dart';
import '../widgets/dialogs.dart';
import '../networking/api.dart' as api;
import '../models/patient.dart';
import './home/homeTab.dart';
import './appointments/appointmentsTab.dart';
import './search/searchDoctorTab.dart';
import './incomingCallPage.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/mainpage';

  @override
  _TabbedPagesState createState() => _TabbedPagesState();
}

class _TabbedPagesState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  Patient patient;
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Home',
      icon: Icon(Icons.home),
    ),
    Tab(text: 'Appointments', icon: Icon(Icons.view_list)),
    Tab(text: 'Search Doctor', icon: Icon(Icons.search)),
  ];

  TabController _tabController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _sendToken() async {
    try {
      patient = Patient.fromJson(await api.patientDetails());
      setState(() {});
      await api.sendToken(patient.id, await _firebaseMessaging.getToken());
    } catch (e) {
      print(e.toString());
    }
  }

  void _logOut(BuildContext context) async {
    bool success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        api.patientLogOut().then((data) {
          Navigator.pop<bool>(context, true);
        }, onError: (e) {
          print(e.toString());
          Navigator.pop<bool>(context, false);
        });
        return LoadingDialog(message: 'Logging Out');
      },
    );
    if (success) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('jwt');
        Navigator.popUntil(context, ModalRoute.withName('/'));
      } catch (e) {
        print(e.toString());
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return FailureDialog(
            contentText: 'Logout Failed',
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    _sendToken();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('message');
        print(message['data']['token']);
        Navigator.pushNamed(context, IncomingCall.routeName, arguments: {
          'token': message['data']['token'],
          'doctor_name': message['data']['doctor_name'],
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('launch');
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('resume');
        print(message);
      },
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
        centerTitle: true,
        title: Text('ShasthoSheba'),
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
                  patient == null
                      ? Loading()
                      : Text(
                          patient.name,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () => _logOut(context),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeTab(),
          AppointmentsTab(),
          SearchDoctorTab(),
        ],
      ),
    );
  }
}
