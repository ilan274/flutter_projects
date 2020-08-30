import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';

const request = "https://api.hgbrasil.com/finance?format=json&?key=adeba566&";

void main() async {
  http.Response response = await http.get(request);
  print(response.body);

  runApp(MaterialApp(
    title: 'Initial Setup Title',
    home: Container(color: Colors.blueAccent)
  ));
}