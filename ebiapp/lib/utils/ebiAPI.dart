import 'package:ebiapp/utils/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EBIapi {
  Future<UserData> fetchUser(String username, String password) async {
    final response = await http.get(
        'https://ebi-api.herokuapp.com/users/' + username + '/' + password);

    if (response.statusCode == 200) {
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

  List<ClientTable> parseTables(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ClientTable>((json) => ClientTable.fromJson(json))
        .toList();
  }

  Future<List<ClientTable>> fetchTables(int userID) async {
    final response = await http
        .get('http://ebi-api.herokuapp.com/userTables/' + userID.toString());
    if (response.statusCode == 200) {
      return parseTables(response.body);
    } else {
      throw Exception('Unable to fetch tables from the REST API');
    }
  }
}
