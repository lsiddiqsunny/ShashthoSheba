import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './doctorModel.dart';
import './filterBar.dart';
import './doctorList.dart';

class SearchDoctorTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => DoctorModel(10),
      child: Builder(
        builder: (context) {
          DoctorModel doctorModel = Provider.of<DoctorModel>(context);
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Search By',
                    style: theme.textTheme.title,
                  ),
                ),
              ),
              FilterBar(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    doctorModel.streamController.add(value);
                  },
                  controller: doctorModel.searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
              ),
              DoctorList(),
            ],
          );
        },
      ),
    );
  }
}
