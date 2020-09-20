import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_form/controller.dart';

class BodyWidget extends StatelessWidget {
  final controller = Controller();

  _textField({String labelText, onChanged, errorText}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText == null ? null : errorText(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Observer(builder: (_context) {
              return _textField(
                labelText: 'First name',
                onChanged: controller.client.changeName,
                errorText: controller.validateName,
              );
            }),
            SizedBox(height: 28.0),
            Observer(builder: (_context) {
              return _textField(
                labelText: 'Email',
                onChanged: controller.client.changeEmail,
                errorText: controller.validateEmail,
              );
            }),
            Divider(height: 40.0, thickness: 1),
            Observer(builder: (_) {
              return RaisedButton(
                onPressed: controller.isValid ? () {} : null,
                child: Text('Save'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
