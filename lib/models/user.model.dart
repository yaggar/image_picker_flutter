//Modelo Usuario

import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  int id;
  String firstName;
  String lastName;
  String avatar;
  bool blocked;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.blocked,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        blocked: json["blocked"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "blocked": blocked,
      };
}