import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&?key=adeba566&";

void main() async {
  runApp(MaterialApp(
      title: 'Initial Setup Title',
      home: Home()
      ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  // Async api request
  return json.decode(response.body);
  // Mapping the return (objectifying
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text('\$ Currency Converter \$'),
      centerTitle: true,
    ),);
  }
}

