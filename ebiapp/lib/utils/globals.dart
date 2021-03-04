library globals;

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;

//{"ID":,"UName":"","Email":"","password":"","IdCliente":}
//class and factory constructor
class UserData {
  final int id;
  final String uname;
  final String email;
  final String password;
  final int idcliente;

  UserData({this.id, this.uname, this.email, this.password, this.idcliente});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json['ID'],
        uname: json['UName'],
        email: json['Email'],
        password: json['password'],
        idcliente: json['IdCliente']);
  }
}

String generateMd5(String input) {
  return crypto.md5.convert(utf8.encode(input)).toString();
}
