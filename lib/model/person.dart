import 'package:flutter/cupertino.dart';
import 'package:login_signup_sqflite/database/local_Database.dart';

class Person {
  int? ID;
  String username;
  String password;

  Person({this.ID, required this.username, required this.password});

  static fromMap(Map<String, dynamic> map) {
    Person a = Person(
      ID: map["ID"],
      username: map["username"],
      password: map["password"],
    );
    return a;
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'username': this.username,
      'password': this.password,
    };
  }
}
