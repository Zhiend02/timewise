class ChatUser {
  ChatUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.middleName,
    required this.email,
    required this.fullName,
    required this.pushToken,
    required this.image,
  });

  late final String uid;
  late String image;
  late final String firstName;
  late final String lastName;
  late final String role;
  late final String middleName;
  late final String email;
  late final String fullName;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json){
    uid = json['uid'];
    image = json['image'] ?? '';
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    middleName = json['middleName'];
    email = json['email'];
    fullName = '$firstName ${middleName.isNotEmpty ? '$middleName ' : ''}$lastName';
    pushToken = json['push_token'] ?? '';


  }


  String get fullname =>  '${['firstName']} ${['middleName']} ${['lastName']}';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['image'] = image;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['role'] = role;
    data['middleName'] = middleName;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}