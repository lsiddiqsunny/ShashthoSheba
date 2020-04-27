
class Patient {
  final String name;
  final String mobileNo;
  final DateTime dob;
  final String sex;
  final String password;

  Patient({this.name, this.mobileNo, this.dob, this.sex, this.password});

  Patient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mobileNo = json['mobile_no'],
        dob = json['date_of_birth'],
        sex = json['sex'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobile_no': mobileNo,
        'date_of_birth': dob.toString(),
        'sex': sex,
        'password': password
      };
}
