import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../api.dart' as api;
import '../../models/transaction.dart';
import './item.dart';
import './addTransactionForm.dart';
import './transactionModel.dart';

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
              trailing: OutlineButton(
                textColor: Colors.blue,
                child: Text('Join'),
                onPressed: null,
              ),
            );
          },
          body: ChangeNotifierProvider(
            create: (context) => TransactionModel(item.appointment.id),
            child: Builder(
              builder: (context) {
                TransactionModel transactionModel =
                    Provider.of<TransactionModel>(context);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('Payment Status'),
                      subtitle: Text(item.appointment.status
                          ? 'Done'
                          : transactionModel.transactions.isEmpty
                              ? 'Not Provided'
                              : 'Awaiting Approval'),
                      trailing: _AddTransactionButton(
                        item: item,
                        transactionModel: transactionModel,
                      ),
                    ),
                    transactionModel.status == Status.loading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _TransactionList(transactionModel)
                  ],
                );
              },
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final TransactionModel transactionModel;

  _TransactionList(this.transactionModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...transactionModel.transactions.map<ListTile>((transaction) {
          return ListTile(
            title: Text('Transaction ID:'),
            subtitle: Text(transaction.transactionId),
            trailing: Text(transaction.amount.toString() + '/='),
          );
        }).toList(),
        ListTile(
          trailing:
              Text('Total = ' + transactionModel.totalAmount.toString() + '/='),
        ),
      ],
    );
  }
}

class _AddTransactionButton extends StatelessWidget {
  final Item item;
  final TransactionModel transactionModel;

  _AddTransactionButton({this.item, this.transactionModel});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: Colors.blue,
      child: Text('Add Payment'),
      onPressed: item.appointment.status
          ? null
          : () async {
              Transaction transaction = await showDialog<Transaction>(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text('New Transaction'),
                    content: AddTransactionForm(),
                  );
                },
              );
              if (transaction != null) {
                transaction.appointmentId = item.appointment.id;
                if (await _postTransaction(transaction)) {
                  transactionModel.add(transaction);
                }
              }
            },
    );
  }
}

Future<bool> _postTransaction(Transaction transaction) async {
  int statusCode = await api.addTransaction(transaction);
  if (statusCode == 200) {
    print('success');
    return true;
  } else {
    print(statusCode);
    return false;
  }
}
