
class Patient {
  final String id;
  final String name;
  final String mobileNo;
  final DateTime dob;
  final String sex;
  final String password;

  Patient({this.id, this.name, this.mobileNo, this.dob, this.sex, this.password});

  Patient.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        mobileNo = json['mobile_no'],
        dob = DateTime.parse(json['date_of_birth']),
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
