import '../../models/appointment.dart';

class Item {
  Appointment appointment;
  bool isExpanded;

  Item({
    this.appointment,
    this.isExpanded,
  });
}