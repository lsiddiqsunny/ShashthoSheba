class Doctor {
  String name;
  String email;
  String mobileNo;
  String institution;
  String speciality;
  String designation;
  String registrationNo;
  String referrer;

  Doctor({
    this.name,
    this.email,
    this.mobileNo,
    this.institution,
    this.speciality,
    this.designation,
    this.registrationNo,
    this.referrer,
  });

  Doctor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mobileNo = json['mobile_no'],
        email = json['email'],
        designation = json['designation'],
        institution = json['institution'],
        speciality = json['speciality'],
        registrationNo = json['reg_number'];
}
