

import 'dart:convert';

import 'package:personal_dashboard_frontend/Data/user.dart';
import 'package:http/http.dart' as http;
// Future<List<User>>fetchUserList() async
// {
//   final response =
//       await http.get(Uri.http("localhost8000", "api/user/"));
//
//   if (response.statusCode == 200) {
//     var responseJson = json.decode(response.body);
//     return (responseJson as List).map((p) => MenuItem.fromJson(p)).toList();
//   }
//   throw Exception('Failed to load client list');
// }


void sendAccForToken() async
{

  Map<String, dynamic> map =
  {
    'username': 'marcogold',
    'password': 'marcodeaur'
  };


final response =
    await http.post(Uri.http("localhost:8000", "api-token-auth"),
      body: jsonEncode(map),
    );
}


Future<String> fetchToken() async
{
  final response = await http.get(Uri.http("localhost", "api-token-auth"));

  if (response.statusCode ==200)
    {
      var token =json.decode(response.body)['token'];
      return token;
    }

  return "";
}