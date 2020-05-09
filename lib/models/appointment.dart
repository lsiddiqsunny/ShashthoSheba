class Appointment {
  final String id;
  final String doctorMobileNo;
  final String patientMobileNo;
  final String doctorName;
  final DateTime dateTime;
  final int status;
  final int serialNo;
  final String imageURL;

  Appointment(
      {this.id,
      this.doctorMobileNo,
      this.patientMobileNo,
      this.doctorName,
      this.dateTime,
      this.status,
      this.serialNo,
      this.imageURL});

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        doctorMobileNo = json['doc_mobile_no'],
        patientMobileNo = json['patient_mobile_no'],
        doctorName = json['doc_name'],
        status = json['status'],
        serialNo = json['serial_no'],
        dateTime = DateTime.parse(json['appointment_date_time']),
        imageURL = json['prescription_img'];
}
