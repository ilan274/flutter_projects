import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String _infoText = 'Enter your data';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Enter your data';
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double bmi = (weight / (height * height));
      String bmiPrecised = bmi.toStringAsPrecision((4));
      print(bmiPrecised);
      if (bmi < 18.5) {
        _infoText = 'Under Weight (${bmiPrecised})';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        _infoText = 'Healthy Weight (${bmiPrecised})';
      } else if (bmi >= 25 && bmi <= 29.9) {
        _infoText = 'Overweight (${bmiPrecised})';
      } else if (bmi >= 30 && bmi < 39.9) {
        _infoText = 'Obesity (${bmiPrecised})';
      } else {
        _infoText = 'Severe Obesity (${bmiPrecised})';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _resetFields,
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person_outline, size: 120, color: Colors.blueGrey),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Weight (kg):",
                    labelStyle: TextStyle(color: Colors.lightGreen)),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: weightController,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Height (cm):",
                    labelStyle: TextStyle(color: Colors.lightGreen)),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: heightController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: _calculate,
                    child: Text(
                      'Calculate',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25),
              )
            ],
          ),
        ));
  }
}
