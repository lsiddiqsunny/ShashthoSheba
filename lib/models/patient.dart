import 'package:intl/intl.dart';

class Patient {
  final String name;
  final String mobileNo;
  final DateTime dob;
  final String sex;
  final String password;

  Patient({this.name, this.mobileNo, this.dob, this.sex, this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_no': mobileNo,
        'date_of_birth': DateFormat.yMd().format(dob),
        'sex': sex,
        'password': password
      };
}
