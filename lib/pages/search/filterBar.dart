import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './doctorModel.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DoctorModel doctorModel = Provider.of<DoctorModel>(context);
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorModel.filter = Filter.name;
              if (doctorModel.searchController.text != '') {
                doctorModel.fetchDoctors(1,
                    filter: doctorModel.filter,
                    value: doctorModel.searchController.text);
              }
            },
            icon: Icon(Icons.person_outline),
            label: Text('Doctor'),
          ),
          secondChild: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person_outline),
            label: Text('Doctor'),
            color: theme.primaryColor,
          ),
          crossFadeState: doctorModel.filter == Filter.name
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorModel.filter = Filter.hospital;
              if (doctorModel.searchController.text != '') {
                doctorModel.fetchDoctors(1,
                    filter: doctorModel.filter,
                    value: doctorModel.searchController.text);
              }
            },
            icon: Icon(Icons.local_hospital),
            label: Text('Hospital'),
          ),
          secondChild: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.local_hospital),
            label: Text('Hospital'),
            color: theme.primaryColor,
          ),
          crossFadeState: doctorModel.filter == Filter.hospital
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorModel.filter = Filter.speciality;
              if (doctorModel.searchController.text != '') {
                doctorModel.fetchDoctors(1,
                    filter: doctorModel.filter,
                    value: doctorModel.searchController.text);
              }
            },
            icon: Icon(Icons.healing),
            label: Text('Speciality'),
          ),
          secondChild: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.healing),
            label: Text('Speciality'),
            color: theme.primaryColor,
          ),
          crossFadeState: doctorModel.filter == Filter.speciality
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
