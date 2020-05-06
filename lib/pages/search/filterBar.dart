import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/doctorProvider.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DoctorProvider doctorProvider = Provider.of<DoctorProvider>(context);
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorProvider.filter = Filter.name;
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
          crossFadeState: doctorProvider.filter == Filter.name
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorProvider.filter = Filter.hospital;
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
          crossFadeState: doctorProvider.filter == Filter.hospital
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              doctorProvider.filter = Filter.speciality;
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
          crossFadeState: doctorProvider.filter == Filter.speciality
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
