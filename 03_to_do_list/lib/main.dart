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

  Map<String, dynamic> _lastRemoved;
  // List with the last removed item
  int _lastRemovedPos;
  // Last removed item position (index)

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  final _itemController = TextEditingController();

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo['title'] = _itemController.text;
      _itemController.text = '';
      newTodo['checked'] = false;
      _toDoList.add(newTodo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
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
              child: RefreshIndicator(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem,
                  ),
                  onRefresh: _refresh)),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent[700],
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]['title']),
        value: _toDoList[index]['checked'],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]['checked'] ? Icons.check : Icons.error),
        ),
        onChanged: (value) {
          setState(() {
            _toDoList[index]['checked'] = value;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        // on dismiss action (slide)
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          _saveData();
        });

        final snack = SnackBar(
          content: Text('Task: "${_lastRemoved['title']}" removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _toDoList.insert(_lastRemovedPos, _lastRemoved);
                _saveData();
              });
            },
          ),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }
}
