import 'package:sqflite/sqflite.dart';

final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';

class ContactHelper {}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img; // location where img was saved in the phone

  Contact.fromMap(Map conMap) {
    id = conMap[idColumn];
    name = conMap[nameColumn];
    email = conMap[emailColumn];
    phone = conMap[phoneColumn];
    img = conMap[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)';
  }
}
