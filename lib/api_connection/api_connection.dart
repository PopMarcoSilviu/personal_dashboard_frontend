import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:personal_dashboard_frontend/Data/user.dart';


Future<String> login(username, password) async {
  Map<String, dynamic> map = {'username': username, 'password': password};

  final response = await http.post(
    Uri.http("192.168.0.110:8000", "api-token-auth/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );


  switch(response.statusCode)
  {
    case 200:
      {
        return json.decode(response.body)['token'];
      }
    case 400:
      {
        return '';

      }
    default:
      {
        throw Exception('User login unexpected problem' + response.statusCode.toString()  );
      }
  }
}

Future<String> register(User user) async {
  Map<String, dynamic> map = user.toDatabaseJson();


  final response = await http.post(
    Uri.http("192.168.0.110:8000", "api-token-auth/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var token = json.decode(response.body)['token'];
    return token;
  }

  throw Exception('Couldn\'t register');
}
