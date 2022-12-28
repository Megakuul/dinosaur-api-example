import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchDinosaurs(String uri) async {
  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load Dinosaurs');
  }
}

Future<bool> postDinosaur(String uri, Object body) async {
  final response = await http.post(Uri.parse(uri), body: json.encode(body), headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteDinosaur(String uri) async {
  final response = await http.delete(Uri.parse(uri));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
