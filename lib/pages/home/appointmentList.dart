import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/transaction.dart';
import '../../models/appointment.dart';
import '../../widgets/loading.dart';
import '../../widgets/dialogs.dart';
import '../../providers/transactionProvider.dart' as transaction;
import '../../providers/todaysAppointmentProvider.dart';
import './addTransactionForm.dart';

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    AppointmentProvider appointmentProvider =
        Provider.of<AppointmentProvider>(context);
    return appointmentProvider.status == Status.loading
        ? Loading()
        : appointmentProvider.appointments.isEmpty
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
                    appointmentProvider.expand(index);
                    if (!isExpanded &&
                        appointmentProvider
                                .transactionProviders[index].status ==
                            transaction.Status.loading) {
                      appointmentProvider.transactionProviders[index]
                          .fetchTransactions();
                    }
                  },
                  children: appointmentProvider.appointments
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
                                  ),
                                );
                              },
                              body: ChangeNotifierProvider.value(
                                value: appointmentProvider
                                    .transactionProviders[index],
                                child: Builder(
                                  builder: (context) {
                                    transaction.TransactionProvider
                                        transactionProvider = Provider.of<
                                            transaction
                                                .TransactionProvider>(context);
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
                                                : transactionProvider
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
                                        transactionProvider.status ==
                                                transaction.Status.loading
                                            ? Loading()
                                            : _TransactionList()
                                      ],
                                    );
                                  },
                                ),
                              ),
                              isExpanded: appointmentProvider.expanded[index],
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
    transaction.TransactionProvider transactionProvider =
        Provider.of<transaction.TransactionProvider>(context);
    return transactionProvider.transactions.isEmpty
        ? ListTile(
            title: Text(
              'No Transactions Added',
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: <Widget>[
              ...transactionProvider.transactions.map<Padding>((transaction) {
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
                  'Total ' + transactionProvider.totalAmount.toString() + '/-',
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
    transaction.TransactionProvider transactionProvider =
        Provider.of<transaction.TransactionProvider>(context);
    return OutlineButton(
      borderSide: BorderSide(color: theme.primaryColor),
      child: Text(
        'Add Payment',
        style: theme.textTheme.button.copyWith(fontWeight: FontWeight.bold),
      ),
      onPressed:
          appointment.status || DateTime.now().isAfter(appointment.dateTime)
              ? null
              : () async {
                  Transaction transaction = await showDialog<Transaction>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('New Transaction'),
                        content: AddTransactionForm(appointment.id),
                      );
                    },
                  );
                  if (transaction != null) {
                    if (await transactionProvider.addTransaction(transaction)) {
                      print('Transaction Added Successfully');
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return SuccessDialog(
                            contentText: 'Transaction Added Successfully',
                          );
                        },
                      );
                    } else {
                      print('Failed to Add Transaction');
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return FailureDialog(
                            contentText: 'Failed to Add Transaction',
                          );
                        },
                      );
                    }
                  }
                },
    );
  }
}
