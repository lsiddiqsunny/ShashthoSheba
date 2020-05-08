import 'package:flutter/material.dart';

import '../../models/transaction.dart';

class AddTransactionForm extends StatefulWidget {
  final String appointmentId;

  AddTransactionForm(this.appointmentId);

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _transactionIdController = TextEditingController();
  final _transactionAmountController = TextEditingController();

  @override
  void dispose() {
    _transactionAmountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _transactionIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
              ),
            ),
            TextFormField(
              controller: _transactionAmountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    borderSide: BorderSide(color: theme.primaryColor),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.button,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: theme.primaryColor),
                    child: Text(
                      'Submit',
                      style: theme.textTheme.button,
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Transaction transaction = Transaction(
                            appointmentId: widget.appointmentId,
                            transactionId: _transactionIdController.text,
                            amount:
                                int.parse(_transactionAmountController.text));
                        Navigator.pop<Transaction>(context, transaction);
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
