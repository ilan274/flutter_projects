import 'package:mobx/mobx.dart';
import 'package:mobx_form/models/client.dart';
part 'controller.g.dart';

class Controller = _ControllerBase with _$Controller;

abstract class _ControllerBase with Store {
  var client = Client();

  String validateName() {
    if (client.name == null || client.name.isEmpty) {
      return 'Required field';
    } else if (client.name.length < 3) {
      return 'Your name must have at least 3 characters';
    }
    return null;
  }
}
