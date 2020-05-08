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
          firstChild: OutlineButton(
            onPressed: () {
              doctorProvider.filter = Filter.name;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.person_outline),
                Text('Doctor'),
              ],
            ),
          ),
          secondChild: RaisedButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.person_outline),
                Text('Doctor'),
              ],
            ),
            color: theme.primaryColor,
          ),
          crossFadeState: doctorProvider.filter == Filter.name
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton(
            onPressed: () {
              doctorProvider.filter = Filter.hospital;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.local_hospital),
                Text('Hospital'),
              ],
            ),
          ),
          secondChild: RaisedButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.local_hospital),
                Text('Hospital'),
              ],
            ),
            color: theme.primaryColor,
          ),
          crossFadeState: doctorProvider.filter == Filter.hospital
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton(
            onPressed: () {
              doctorProvider.filter = Filter.speciality;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.healing),
                Text('Speciality'),
              ],
            ),
          ),
          secondChild: RaisedButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.healing),
                Text('Speciality'),
              ],
            ),
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
