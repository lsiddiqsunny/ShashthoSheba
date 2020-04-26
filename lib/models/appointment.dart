import 'package:intl/intl.dart';

class Appointment {
  String id;
  String doctorMobileNo;
  String patientMobileNo;
  String doctorName;
  DateTime dateTime;
  bool status;

  Appointment({this.id, this.doctorMobileNo, this.patientMobileNo, this.doctorName, this.dateTime, this.status});

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        doctorMobileNo = json['doc_mobile_no'],
        patientMobileNo = json['patient_mobile_no'],
        doctorName = json['doc_name'],
        status = json['status'],
        dateTime = DateTime.parse(json['appointment_date'] + ' ' + json['appointment_time']);
}
