import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:personal_dashboard_frontend/data/aux_data.dart';
import 'package:personal_dashboard_frontend/data/user.dart';


Future<String> login(username, password) async {
  Map<String, dynamic> map = {'username': username, 'password': password};

  final response = await http.post(
    Uri.http("192.168.43.243:8000", "api-token-auth/"),
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
    Uri.http("192.168.43.243:8000", "api/user/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  switch (response.statusCode)
  {
    case 201:
      {
        return 'OK';
      }
    case 400:
      {
        String returnMsg= "";
        print(jsonDecode(response.body)['email']);
        jsonDecode(response.body).forEach((k,v) => returnMsg = returnMsg + v.toString());

        return returnMsg;
      }
  }


  throw Exception('User registration unexpected problem' + response.statusCode.toString());
}
