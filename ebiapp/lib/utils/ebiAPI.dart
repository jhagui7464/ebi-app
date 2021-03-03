import 'package:http/http.dart' as http;
import 'dart:convert';

class EBIapi {
  static Future<int> fetchUser(http.Client client, String username) async {
    final response =
        await client.get('https://ebi-api.herokuapp.com/user/' + username);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print(response.body);
      return json["ID"]["Email"]["password"]["IdCliente"];
    } else {
      throw Exception('Failed to find user');
    }
  }
}
