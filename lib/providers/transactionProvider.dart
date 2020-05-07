import 'package:flutter/foundation.dart';
import 'dart:collection';

import '../models/transaction.dart';
import '../networking/api.dart' as api;

enum Status { loading, completed, error }

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  Status _status = Status.loading;
  String _appointmentId;

  TransactionProvider(this._appointmentId) {
    // _fetchTransactions(appointmentId);
  }

  UnmodifiableListView<Transaction> get transactions =>
      UnmodifiableListView(_transactions);

  Status get status => _status;

  double get totalAmount {
    double total = 0;
    _transactions
        .asMap()
        .forEach((idx, transaction) => total += transaction.amount);
    return total;
  }

  Future<bool> addTransaction(Transaction transaction) async {
    try {
      await api.addTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void fetchTransactions() async {
    List<Transaction> newList = await _getList(_appointmentId);
    _status = Status.completed;
    _transactions = newList;
    notifyListeners();
  }
}

Future<List<Transaction>> _getList(String appointmentId) async {
  try {
    final data = await api.fetchTransactions(appointmentId);
    return data.map<Transaction>((json) {
      return Transaction.fromJson(json);
    }).toList();
  } catch (e) {
    print(e.toString());
    return [];
  }
}
