import 'package:ebiapp/utils/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EBIapi {
  Future<UserData> fetchUser(String username) async {
    final response =
        await http.get('https://ebi-api.herokuapp.com/users/' + username);

    if (response.statusCode == 200) {
      // Map<String, dynamic> json = jsonDecode(response.body);
      // ////{"ID":,"UName":"","Email":"","password":"","IdCliente":}
      // return json["ID"]["UName"]["Email"]["password"]["IdCliente"];

      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(UserData.fromJson(jsonDecode(response.body)));
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user data');
    }
  }
}
