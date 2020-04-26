import '../../models/appointment.dart';
import '../../models/transaction.dart';

class Item {
  Appointment appointment;
  bool isExpanded;
  List<Transaction> transactions = [];

  Item({
    this.appointment,
    this.isExpanded,
  });
}