import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:personal_dashboard_frontend/data/data.dart';
import 'package:personal_dashboard_frontend/data/personalDashboard.dart';
import 'package:personal_dashboard_frontend/data/user.dart';
import 'package:tuple/tuple.dart';
import 'package:image/image.dart' as I;

dynamic getHeadersCookie(String? cookie) {
  Map<String, String> headers = {};
  if (cookie != null) {
    RegExp regExp = new RegExp(r'((cs|se).*?;)');
    String out = '';
    for (var item in regExp.allMatches(cookie)) {
      out += cookie.substring(item.start, item.end);
    }

    headers['cookie'] = out.substring(0, out.length - 1);
  }

  return headers;
}

Future<List<Note>> getNotes(cookie, name, pd) async {
  final Map<String, dynamic> parameters = {
    'name': name,
    'pd': pd.toString(),
  };

  final response = await http.get(
    Uri.http("192.168.43.243:8000", "api/user-note/", parameters),
    headers: getHeadersCookie(cookie),
  );

  List<dynamic> json_data = json.decode(response.body);

  List<Note> list = json_data.map((note) => Note.fromDatabaseJson(note)).toList();

  return list;
}

Future<Uint8List> getDrawing(cookie, name) async {
  final Map<String, dynamic> parameters = {
    "name": name,
  };

  final response = await http.get(
    Uri.http("192.168.43.243:8000", "api/user-drawing/", parameters),
    headers: getHeadersCookie(cookie),
  );

  var list = response.body
      .substring(2, response.body.length - 2)
      .split(',')
      .map((e) => int.parse(e))
      .toList();

  return Uint8List.fromList(list);
}

Future<bool> postDrawing(list, pd_name, cookie, pd) async {
  final Map<String, String> data = {
    'name': pd_name,
    'drawing': jsonEncode(list),
    'pd': pd.toString(),
  };

  final response = await http.post(
    Uri.http("192.168.43.243:8000", "api/user-drawing/"),
    headers: getHeadersCookie(cookie),
    body: data,
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<List<PersonalDashboard>> getPDsFromUser(user_id, cookie) async {
  final Map<String, dynamic> parameters = {
    "user": user_id.toString(),
    "get_all": 'True'
  };

  final response = await http.get(
      Uri.http("192.168.43.243:8000", "api/user-pd/", parameters),
      headers: getHeadersCookie(cookie));

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);

    return (responseJson as List)
        .map((e) => PersonalDashboard.fromDatabaseJson(e))
        .toList();
  }

  throw HttpException('User dashboards search didn\'t work');
}

Future<Tuple2<int, dynamic>> login(username, password) async {
  Map<String, dynamic> map = {
    'username': username,
    'password': password,
  };

  final response = await http.post(
    Uri.http("192.168.43.243:8000", "api/login/"),
    body: map,
    headers: <String, String>{
      "Content-Type": "application/x-www-form-urlencoded",
    },
  );

  switch (response.statusCode) {
    case 200:
      {
        return Tuple2(
          json.decode(response.body)['id'],
          response.headers['set-cookie'],
        );
      }
    case 404:
      {
        return Tuple2(-1, -1);
      }
    default:
      {
        throw Exception(
            'User login unexpected problem' + response.statusCode.toString());
      }
  }
}

Future<String> register(User user, pass2) async {
  Map<String, dynamic> map = user.toDatabaseJson();
  map['password1'] = user.password;
  map['password2'] = pass2;

  final response = await http.post(
    Uri.http("192.168.43.243:8000", "api/register/"),
    body: jsonEncode(map),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  switch (response.statusCode) {
    case 201:
      {
        return 'OK';
      }
    case 400:
      {
        String returnMsg = "";
        jsonDecode(response.body)
            .forEach((k, v) => returnMsg = returnMsg + v.toString());

        return returnMsg;
      }
  }

  throw Exception(
      'User registration unexpected problem' + response.statusCode.toString());
}
