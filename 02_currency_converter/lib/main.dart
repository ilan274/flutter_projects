import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/?key=adeba566";

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
  final usdController = TextEditingController();
  final btcController = TextEditingController();
  final brlController = TextEditingController();

  double dolar;
  double bitcoin;

  void clearAll() {
    usdController.text = '';
    btcController.text = '';
    brlController.text = '';
  }

  void _usdChanged(String value) {
    if (usdController.text.isEmpty) {
      return clearAll();
    }
    double dolar = double.parse(value);
    brlController.text = (dolar * this.dolar).toStringAsFixed(2);
    btcController.text = (dolar / this.bitcoin).toStringAsFixed(2);
  }

  void _btcChanged(String value) {
    if (btcController.text.isEmpty) {
      return clearAll();
    }
    print(this.bitcoin);
    double bitcoin = double.parse(value);
    brlController.text = ((bitcoin * this.bitcoin) * dolar).toStringAsFixed(2);
    usdController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
  }

  void _brlChanged(String value) {
    if (brlController.text.isEmpty) {
      return clearAll();
    }
    double real = double.parse(value);
    usdController.text = (real / this.dolar).toStringAsFixed(2);
    btcController.text =
        (real / (this.bitcoin * this.dolar)).toStringAsFixed(8);
  }

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
                  bitcoin =
                      snapshot.data['results']['bitcoin']['coinbase']['last'];
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
                            'USD amount', '\$ ', usdController, _usdChanged),
                        // TextField function
                        Divider(
                          height: 40,
                        ),
                        // Space between
                        buildTextField('Bitcoin', 'Enter the amount in BTC',
                            'BTC amount', 'Ƀ ', btcController, _btcChanged),
                        Divider(
                          height: 40,
                        ),
                        buildTextField(
                            'Brazilian Real',
                            'Enter the amount in BRL',
                            'BRL amount',
                            'R\$ ',
                            brlController,
                            _brlChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String hintText, String helperText, String labelText,
    String prefixText, TextEditingController controller, Function change) {
  return TextField(
    controller: controller,
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
    onChanged: change,
  );
}
