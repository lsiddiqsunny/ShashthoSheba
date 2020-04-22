import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<_Item> _data = _Item.createList();
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
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                _data[index].isExpanded = !isExpanded;
              });
            },
            children: _data.map<ExpansionPanel>((item) {
              return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(DateFormat.jm().format(item.dateTime)),
                    subtitle: Text('with ${item.doctorName}'),
                  );
                },
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('Payment Status'),
                      subtitle: Text(item.paymentStatus),
                      trailing: RaisedButton(
                        child: Text('Add Payment'),
                        onPressed: item.paymentStatus == 'Done'
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
          ),
        ],
      ),
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
  DateTime dateTime;
  String doctorName;
  String paymentStatus;
  bool isExpanded;
  List<_Transaction> transactions;

  static var entries = [
    {
      'doctorName': 'Dr.Shahidul Islam',
      'paymentStatus': 'Not Provided',
      'transactions': [
        _Transaction(
          '1234',
          400,
        ),
        _Transaction(
          '2345',
          500,
        )
      ],
    },
  ];

  _Item({
    this.dateTime,
    this.doctorName,
    this.paymentStatus,
    this.isExpanded = false,
    this.transactions = const [],
  });

  static List<_Item> createList() {
    return List.generate(entries.length, (index) {
      return _Item(
        dateTime: DateTime.now(),
        doctorName: entries[index]['doctorName'],
        paymentStatus: entries[index]['paymentStatus'],
        transactions: entries[index]['transactions'],
      );
    });
  }
}
