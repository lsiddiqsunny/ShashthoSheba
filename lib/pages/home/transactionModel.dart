import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';

import '../../models/transaction.dart';
import '../../api.dart' as api;

enum Status {loading, completed, error}

class TransactionModel extends ChangeNotifier {
  List<Transaction> _transactions = [];
  Status _status = Status.loading;
  String _appointmentId;

  TransactionModel(this._appointmentId) {
    // _fetchTransactions(appointmentId);
  }

  UnmodifiableListView<Transaction> get transactions => UnmodifiableListView(_transactions);

  Status get status => _status;

  double get totalAmount {
    double total = 0;
    _transactions.asMap().forEach((idx, transaction) => total += transaction.amount);
    return total;
  }

  void add(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void fetchTransactions() async {
    List<Transaction> newList = await _getList(_appointmentId);
    _status = Status.completed;
    _transactions = newList;
    notifyListeners();
  }

  Future<bool> postTransaction(Transaction transaction) async {
    int statusCode = await api.addTransaction(transaction);
    if (statusCode == 200) {
      print('success');
      return true;
    } else {
      print(statusCode);
      return false;
    }
  }
}

Future<List<Transaction>> _getList(String appointmentId) async {
  final http.Response response = await api.fetchTransactions({'appointment_id': appointmentId});
  if (response.statusCode == 200) {
    return compute(_parseData, response.body);
  } else {
    print(response.statusCode);
    return [];
  }
}

List<Transaction> _parseData(String responseBody) {
  final data = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return data.map<Transaction>((json) {
    return Transaction.fromJson(json);
  }).toList();
}

