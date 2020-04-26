import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../host.dart' as host;
import '../../models/transaction.dart';
import './item.dart';
import './transactionForm.dart';

class AppointmentList extends StatefulWidget {
  final List<Item> data;

  AppointmentList({this.data});

  @override
  _AppointmentListState createState() => _AppointmentListState(data);
}

class _AppointmentListState extends State<AppointmentList> {
  List<Item> data;

  _AppointmentListState(this.data);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(DateFormat.jm().format(item.appointment.dateTime)),
              subtitle: Text('with ${item.appointment.doctorName}'),
            );
          },
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Payment Status'),
                subtitle: Text(item.appointment.status
                    ? 'Done'
                    : item.transactions.isEmpty
                        ? 'Not Provided'
                        : 'Awaiting Approval'),
                trailing: RaisedButton(
                  child: Text('Add Payment'),
                  onPressed: item.appointment.status
                      ? null
                      : () async {
                          Transaction transaction =
                              await showDialog<Transaction>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('New Transaction'),
                                content: TransactionForm(),
                              );
                            },
                          );
                          if (transaction != null) {
                            transaction.appointmentId = item.appointment.id;
                            if (await _addTransaction(transaction)) {
                              setState(() {
                                item.transactions.add(transaction);
                              });
                            }
                          }
                        },
                ),
              ),
              ...item.transactions.map<ListTile>((transaction) {
                return ListTile(
                  title: Text('Transaction ID:'),
                  subtitle: Text(transaction.transactionId),
                  trailing: Text(transaction.amount.toString() + '/='),
                );
              }).toList(),
            ],
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

Future<bool> _addTransaction(Transaction transaction) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    host.loc + '/patient/add/transaction',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    },
    body: jsonEncode(transaction),
  );
  if (response.statusCode == 200) {
    print('success');
    return true;
  } else {
    print(response.statusCode);
    return false;
  }
}