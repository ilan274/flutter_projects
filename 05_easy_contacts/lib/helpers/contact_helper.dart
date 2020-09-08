import 'dart:html';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  // Class only object instance

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  // internal() constructor  - can only be called from inside the class

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contacts.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY,'
        '$nameColumn TEXT, $emailColumn TEXT, $imgColumn TEXT)',
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbConnect = await db;
    // make database connection
    contact.id = await dbConnect.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbConnect = await db;
    // get from sqflite database
    List<Map> maps = await dbConnect.query(
      contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbConnect = await db;
    await dbConnect
        .delete(contactTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future updateContact(Contact contact) async {
    Database dbContact = await _db;
    dbContact.update(contactTable, contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbConnect = await db;
    List listMap = await dbConnect.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }
}

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
