import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=y8UpRrqs2dNmKg8N5f5s2v0tP1LEetzV&limit=25&rating=g');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=y8UpRrqs2dNmKg8N5f5s2v0tP1LEetzV&q=$_search&limit=20&offset=$_offset&rating=g&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((value) {
      print('value, $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif',
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: EdgeInsets.all(10),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: snapshot.data['data'].length, // gifs on screen
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          print('$index');
        },
        child: Image.network(
          snapshot.data['data'][index]['images']['fixed_height']['url'],
          height: 300.0,
          fit: BoxFit.cover,
        ),
      );
    },
  );
}
