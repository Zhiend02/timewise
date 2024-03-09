class UserModel {
  String? email;
  String? role;
  String? uid;
  String? firstName;
  String? middleName;
  String? lastName;


// receiving data
  UserModel({this.uid, this.email, this.role ,this.firstName, this.middleName, this.lastName,});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],


    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    };
  }
}
