import 'package:flutter/material.dart';

import './homeTab.dart';
import './appointmentsTab.dart';
import './searchDoctorTab.dart';

class TabbedPages extends StatefulWidget {
  static const routeName='/tabbedpages';

  @override
  _TabbedPagesState createState() => _TabbedPagesState();
}

class _TabbedPagesState extends State<TabbedPages>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Home',
    ),
    Tab(
      text: 'Appointments',
    ),
    Tab(
      text: 'Search Doctor',
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
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
        bottom: TabBar(controller: _tabController, tabs: myTabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [HomeTab(),AppointmentsTab(),SearchDoctorTab()],
      ),
    );
  }
}
