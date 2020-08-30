import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&?key=adeba566&";

void main() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body)['results']['currencies']['USD']);
  // Accessing inner objects (Map) results > curr > USD

  runApp(MaterialApp(
      title: 'Initial Segit addtup Title',
      home: Container(color: Colors.blueAccent)
  ));
}