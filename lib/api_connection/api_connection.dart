import 'dart:convert';

import 'package:http/http.dart' as http;


Future<bool> checkIfUserExists(username, password, token) async {
  Map<String, dynamic> map = {'username': username, 'password': password};

  final response = await http.put(
    Uri.http("10.0.2.2:8000", "api/user/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'TOKEN ' + await token,
    },
  );


  switch(response.statusCode)
  {
    case 202:
      {
        return true;
      }
    case 400:
      {
        return false;

      }
    default:
      {
        throw Exception('User login unexpected problem' + response.statusCode.toString()  );
      }
  }
}

Future<String> fetchToken() async {
  Map<String, dynamic> map = {
    'username': 'marcogold',
    'password': 'marcodeaur'
  };

  final response = await http.post(
    Uri.http("10.0.2.2:8000", "api-token-auth/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var token = json.decode(response.body)['token'];
    return token;
  }

  throw Exception('Couldn\'t get the token');
}
