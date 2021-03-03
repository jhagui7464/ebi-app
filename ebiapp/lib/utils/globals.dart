library globals;

import 'ebiAPI.dart';

import 'package:http/http.dart' as http;

int userID;

http.Client httpClient = http.Client();
Future<int> retrieveUser(String username) async {
  return EBIapi.fetchUser(httpClient, username);
}
