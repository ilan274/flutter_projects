import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&?key=adeba566&";

void main() async {

  print(await getData());
  // Calling a Future<Map> async function

  runApp(MaterialApp(
      title: 'Initial Segit addtup Title',
      home: Container(color: Colors.blueAccent)));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  // Async api request
  return json.decode(response.body);
  // Mapping the return (objectifying
}
