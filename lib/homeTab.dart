import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'host.dart' as host;
import './models/appointment.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8,
            ),
            child: Text(
              'Appointments Today:',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          FutureBuilder<List<_Item>>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return snapshot.hasData
                  ? _AppointmentList(data: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

class _AppointmentList extends StatefulWidget {
  final List<_Item> data;

  _AppointmentList({this.data});

  @override
  _AppointmentListState createState() => _AppointmentListState(data);
}

class _AppointmentListState extends State<_AppointmentList> {
  List<_Item> data;

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
                subtitle:
                    Text(item.appointment.status ? 'Done' : 'Not Provided'),
                trailing: RaisedButton(
                  child: Text('Add Payment'),
                  onPressed: item.appointment.status
                      ? null
                      : () async {
                          _Transaction transaction =
                              await showDialog<_Transaction>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('New Transaction'),
                                content: _TransactionForm(),
                              );
                            },
                          );
                          setState(() {
                            if (transaction != null) {
                              item.transactions.add(transaction);
                            }
                          });
                        },
                ),
              ),
              ...item.transactions.map<ListTile>((transaction) {
                return ListTile(
                  title: Text('Transaction ID:'),
                  subtitle: Text(transaction.trxId),
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

class _TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<_TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _trxIdController = TextEditingController();
  final _trxAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _trxIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                hasFloatingPlaceholder: true,
              ),
            ),
            TextFormField(
              controller: _trxAmountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                hasFloatingPlaceholder: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: ButtonBar(
                children: <Widget>[
                  RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context)),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _Transaction transaction = _Transaction(
                            _trxIdController.text,
                            int.parse(_trxAmountController.text));
                        Navigator.pop<_Transaction>(context, transaction);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Transaction {
  String trxId;
  int amount;

  _Transaction(this.trxId, this.amount);
}

class _Item {
  Appointment appointment;
  bool isExpanded;
  List<_Transaction> transactions = [];

  _Item({
    this.appointment,
    this.isExpanded,
  });
}

Future<List<_Item>> _getData() async {
  List<Appointment> data = await _getList();
  List<_Item> _data = data.map<_Item>((appointment) {
    return _Item(appointment: appointment, isExpanded: false);
  }).toList();
  return _data;
}

Future<List<Appointment>> _getList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.get(
    host.loc +
        '/patient/get/appointment/' +
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + prefs.getString('jwt'),
    },
  );
  if (response.statusCode == 200) {
    return compute(_parseData, response.body);
  } else {
    print(response.statusCode);
  }
}

List<Appointment> _parseData(String responseBody) {
    final data = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return data.map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
}