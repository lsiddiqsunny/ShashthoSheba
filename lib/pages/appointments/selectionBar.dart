import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './appointmentModel.dart';

class SelectionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppointmentModel appointmentModel = Provider.of<AppointmentModel>(context);
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              appointmentModel.selected = Selected.previous;
            },
            icon: Icon(Icons.history),
            label: Text('Previous'),
          ),
          secondChild: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.history),
            label: Text('Previous'),
            color: theme.primaryColor,
          ),
          crossFadeState: appointmentModel.selected == Selected.previous
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        AnimatedCrossFade(
          firstChild: OutlineButton.icon(
            onPressed: () {
              appointmentModel.selected = Selected.upcoming;
            },
            icon: Icon(Icons.trending_up),
            label: Text('Upcoming'),
          ),
          secondChild: RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.trending_up),
            label: Text('Upcoming'),
            color: theme.primaryColor,
          ),
          crossFadeState: appointmentModel.selected == Selected.upcoming
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
      ],
    );
  }
}