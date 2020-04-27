import 'package:flutter/material.dart';

import '../../models/transaction.dart';

class AddTransactionForm extends StatefulWidget {
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _transactionIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                hasFloatingPlaceholder: true,
              ),
            ),
            TextFormField(
              controller: _transactionAmountController,
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
                        Transaction transaction = Transaction(
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