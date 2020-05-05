
class Appointment {
  final String id;
  final String doctorMobileNo;
  final String patientMobileNo;
  final String doctorName;
  final DateTime dateTime;
  final bool status;

  Appointment({this.id, this.doctorMobileNo, this.patientMobileNo, this.doctorName, this.dateTime, this.status});

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        doctorMobileNo = json['doc_mobile_no'],
        patientMobileNo = json['patient_mobile_no'],
        doctorName = json['doc_name'],
        status = json['status'],
        dateTime = DateTime.parse(json['appointment_date_time']);
}
