import 'package:ebiapp/utils/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EBIapi {
  Future<UserData> fetchUser(String username, String password) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/users/' + username + '/' + password));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(UserData.fromJson(jsonDecode(response.body)));
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user data from REST API');
    }
  }

  List<ClientTable> parseClientTables(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ClientTable>((json) => ClientTable.fromJson(json))
        .toList();
  }

  Future<List<ClientTable>> fetchTables(int userID) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/userTables/' + userID.toString()));
    if (response.statusCode == 200) {
      return parseClientTables(response.body);
    } else {
      throw Exception('Unable to fetch tables from the REST API');
    }
  }

  Future<List<ClientTable>> fetchdoneTables(int userID) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/userTables/done/' + userID.toString()));
    if (response.statusCode == 200) {
      return parseClientTables(response.body);
    } else {
      throw Exception('Unable to fetch done tables from the REST API');
    }
  }

  List<InventoryTable> parseInventoryTables(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<InventoryTable>((json) => InventoryTable.fromJson(json))
        .toList();
  }

  Future<List<InventoryTable>> fetchInventoryTables(int userID) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/inventory/' + userID.toString()));
    if (response.statusCode == 200) {
      return parseInventoryTables(response.body);
    } else {
      throw Exception('Unable to fetch Inventory Tables from the REST API');
    }
  }

  List<Operations> parseOperations(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Operations>((json) => Operations.fromJson(json)).toList();
  }

  Future<List<Operations>> fetchOperations(int userID) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/operations/' + userID.toString()));
    if (response.statusCode == 200) {
      return parseOperations(response.body);
    } else {
      throw Exception('Unable to fetch Operations from the REST API');
    }
  }

  Future<List<Operations>> fetchDoneOperations(int userID) async {
    final response = await http.get(Uri.parse(
        'https://ebi-api.herokuapp.com/operations/done/' + userID.toString()));
    if (response.statusCode == 200) {
      return parseOperations(response.body);
    } else {
      throw Exception('Unable to fetch Done Operations from the REST API');
    }
  }
}
