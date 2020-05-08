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
                                      style: theme.textTheme.headline5.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'with ${appointment.doctorName}',
                                      style: theme.textTheme.bodyText1.copyWith(
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
                                            style: theme.textTheme.headline6,
                                          ),
                                          subtitle: Text(
                                            appointment.status
                                                ? 'Done'
                                                : transactionProvider
                                                        .transactions.isEmpty
                                                    ? 'Not Provided'
                                                    : 'Awaiting Approval',
                                            style: theme.textTheme.bodyText1
                                                .copyWith(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                          trailing: _AddTransactionButton(
                                              appointment),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Transaction ID',
                                            style: theme.textTheme.headline6,
                                          ),
                                          trailing: Text(
                                            'Amount',
                                            style: theme.textTheme.headline6,
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
              ...transactionProvider.transactions
                  .asMap()
                  .map<int, Padding>(
                    (index, transaction) {
                      return MapEntry(
                        index,
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ListTile(
                            leading: Text(
                              (index + 1).toString() +
                                  '. ' +
                                  transaction.transactionId,
                            ),
                            trailing:
                                Text(transaction.amount.toString() + '/-'),
                          ),
                        ),
                      );
                    },
                  )
                  .values
                  .toList(),
              ListTile(
                trailing: Text(
                  'Total ' + transactionProvider.totalAmount.toString() + '/-',
                  style: theme.textTheme.headline6,
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
      onPressed: appointment.status
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
