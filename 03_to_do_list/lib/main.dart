import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  List _toDoList = [];

  final _itemController = TextEditingController();

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = _itemController.text;
      _itemController.text = '';
      newTodo['checked'] = false;
      _toDoList.add(newTodo);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    // Deals with file locations for both IOS and Android devices
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    // Converting the list to json
    final file = await _getFile();
    return file.writeAsString(data);
    // Write inside _getFileFunction (data.json file)
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                        labelText: 'New Task',
                        labelStyle: TextStyle(color: Colors.blueAccent[100])),
                    maxLength: 26,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent[400],
                  child: Text('Add'),
                  textColor: Colors.white,
                  onPressed: _addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_toDoList[index]['title']),
                  value: _toDoList[index]['checked'],
                  secondary: CircleAvatar(
                    child: Icon(_toDoList[index]['checked']
                        ? Icons.check
                        : Icons.error),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _toDoList[index]['checked'] = value;
                    });
                  },
                );
                // 'title' property accepts a Text Widget (text)
              },
            ),
          )
        ],
      ),
    );
  }
}
