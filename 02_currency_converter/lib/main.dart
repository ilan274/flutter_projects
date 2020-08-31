import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&?key=adeba566&";

void main() async {
  runApp(MaterialApp(
    title: 'Initial Setup Title',
    home: Home(),
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
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('\$ Currency Converter \$'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // Verify connection state
              case ConnectionState.none:
              case ConnectionState.waiting:
                // If connection is none || waiting return below
                return Center(
                    child: Text(
                  'Loading data..',
                  style: TextStyle(color: Colors.amber, fontSize: 22),
                  textAlign: TextAlign.center,
                ));
              default:
                // Default case - verify if it succeeded or not
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    'Error loading data :(',
                    style: TextStyle(color: Colors.amber, fontSize: 22),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  return SingleChildScrollView(
                    // Scrolling page
                    padding: EdgeInsets.all(20),
                    // Adding padding to everything inside
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // Aligning icon horizontally
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 120,
                          color: Colors.green,
                        ),
                        buildTextField('US Dollar', 'Enter the amount in USD',
                            'USD amount', '\$ '),
                        // TextField function
                        Divider(
                          height: 40,
                        ),
                        // Space between
                        buildTextField('Bitcoin', 'Enter the amount in BTC',
                            'BTC amount', 'Ƀ '),
                        Divider(
                          height: 40,
                        ),
                        buildTextField('Brazilian Real',
                            'Enter the amount in BRL', 'BRL amount', 'R\$ '),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String hintText, String helperText, String labelText, String prefixText) {
  return TextField(
    keyboardType: TextInputType.number,
    style: TextStyle(color: Colors.blue, fontSize: 20),
    decoration: new InputDecoration(
        hintStyle: TextStyle(color: Colors.blueGrey),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        hintText: hintText,
        helperText: helperText,
        labelText: labelText,
        prefixText: prefixText),
  );
}
