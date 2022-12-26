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
