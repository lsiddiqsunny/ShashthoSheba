import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import './addTransactionForm.dart';
import './transactionModel.dart' as transaction;
import './appointmentModel.dart';

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    AppointmentModel appointmentModel = Provider.of<AppointmentModel>(context);
    return appointmentModel.status == Status.loading
        ? Loading()
        : appointmentModel.appointments.isEmpty
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
                    appointmentModel.expand(index);
                    if (!isExpanded &&
                        appointmentModel.transactionModels[index].status ==
                            transaction.Status.loading) {
                      appointmentModel.transactionModels[index]
                          .fetchTransactions();
                    }
                  },
                  children: appointmentModel.appointments
                      .asMap()
                      .map<int, ExpansionPanel>((index, appointment) {
                        return MapEntry(
                            index,
                            ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      DateFormat.jm()
                                          .format(appointment.dateTime),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'with ${appointment.doctorName}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    trailing: OutlineButton(
                                      borderSide:
                                          BorderSide(color: theme.primaryColor),
                                      child: Text(
                                        'Join',
                                        style: theme.textTheme.button.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              },
                              body: ChangeNotifierProvider.value(
                                value:
                                    appointmentModel.transactionModels[index],
                                child: Builder(
                                  builder: (context) {
                                    transaction.TransactionModel
                                        transactionModel = Provider.of<
                                            transaction
                                                .TransactionModel>(context);
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
                                            appointment.status
                                                ? 'Done'
                                                : transactionModel
                                                        .transactions.isEmpty
                                                    ? 'Not Provided'
                                                    : 'Awaiting Approval',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          trailing: _AddTransactionButton(
                                              appointment),
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
                                        transactionModel.status ==
                                                transaction.Status.loading
                                            ? Loading()
                                            : _TransactionList()
                                      ],
                                    );
                                  },
                                ),
                              ),
                              isExpanded: appointmentModel.expanded[index],
                            ));
                      })
                      .values
                      .toList(),
                ),
              );
  }
}

class _TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    transaction.TransactionModel transactionModel =
        Provider.of<transaction.TransactionModel>(context);
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
  final Appointment appointment;

  _AddTransactionButton(this.appointment);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    transaction.TransactionModel transactionModel =
        Provider.of<transaction.TransactionModel>(context);
    return OutlineButton(
      borderSide: BorderSide(color: theme.primaryColor),
      child: Text(
        'Add Payment',
        style: theme.textTheme.button.copyWith(fontWeight: FontWeight.bold),
      ),
      onPressed: appointment.status
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
                transaction.appointmentId = appointment.id;
                if (await transactionModel.postTransaction(transaction)) {
                  transactionModel.add(transaction);
                }
              }
            },
    );
  }
}
