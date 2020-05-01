import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../api.dart' as api;
import '../../models/transaction.dart';
import '../../widgets/loading.dart';
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
    final ThemeData theme = Theme.of(context);
    return data.isEmpty
        ? ListTile(
            title: Text(
              'No Appointments Today',
              textAlign: TextAlign.center,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  data[index].isExpanded = !isExpanded;
                });
              },
              children: data.map<ExpansionPanel>((item) {
                return ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          DateFormat.jm().format(item.appointment.dateTime),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          'with ${item.appointment.doctorName}',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.primaryColor,
                          ),
                        ),
                        trailing: OutlineButton(
                          borderSide: BorderSide(color: theme.primaryColor),
                          child: Text(
                            'Join',
                            style: theme.textTheme.button
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
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
                              title: Text(
                                'Payment Status',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              subtitle: Text(
                                item.appointment.status
                                    ? 'Done'
                                    : transactionModel.transactions.isEmpty
                                        ? 'Not Provided'
                                        : 'Awaiting Approval',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theme.primaryColor,
                                ),
                              ),
                              trailing: _AddTransactionButton(
                                item: item,
                                transactionModel: transactionModel,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Transaction ID',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              trailing: Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            transactionModel.status == Status.loading
                                ? Loading()
                                : _TransactionList()
                          ],
                        );
                      },
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          );
  }
}

class _TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TransactionModel transactionModel = Provider.of<TransactionModel>(context);
    return transactionModel.transactions.isEmpty
        ? ListTile(
            title: Text(
              'No Transactions Added',
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: <Widget>[
              ...transactionModel.transactions.map<Padding>((transaction) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: ListTile(
                    leading: Text(transaction.transactionId),
                    trailing: Text(transaction.amount.toString() + '/-'),
                  ),
                );
              }).toList(),
              ListTile(
                trailing: Text(
                  'Total ' + transactionModel.totalAmount.toString() + '/-',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor),
                ),
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
    final ThemeData theme = Theme.of(context);
    return OutlineButton(
      borderSide: BorderSide(color: theme.primaryColor),
      child: Text(
        'Add Payment',
        style: theme.textTheme.button.copyWith(fontWeight: FontWeight.bold),
      ),
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
