import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? username;
  final int? userId;

  UserModel({
    this.username,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "userId": userId,
  };
}
