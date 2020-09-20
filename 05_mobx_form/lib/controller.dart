import 'package:mobx/mobx.dart';
part 'controller.g.dart';

class Controller = ControllerBase with _Controller;

abstract class ControllerBase with Store {
  @observable
  String name;
  @action
  changeName(String value) => name = value;

  @observable
  String email;
  @action
  changeEmail(String value) => email = value;

  @observable
  String cpf;
  @action
  changeCpf(String value) => cpf = value;
}
