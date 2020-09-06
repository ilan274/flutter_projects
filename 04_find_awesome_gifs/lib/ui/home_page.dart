import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:find_awesome_gifs/ui/gif_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';

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
          'https://api.giphy.com/v1/gifs/search?api_key=y8UpRrqs2dNmKg8N5f5s2v0tP1LEetzV&q=$_search&limit=19&offset=$_offset&rating=g&lang=en');
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
              onSubmitted: (text) {
                setState(() {
                  (text.isEmpty) ? _search = null : _search = text;
                  _offset = 0;
                });
              },
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

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data['data'][index]),
                    ));
              },
              onLongPress: () async {
                final location = snapshot.data['data'][index];
                var request = await HttpClient().getUrl(
                    Uri.parse(location['images']['fixed_height']['url']));
                var response = await request.close();
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                return await Share.file(location['title'],
                    '${location['id']}.gif', bytes, 'image/gif',
                    text: '${location['title']}\nby Awesome Gifs');
              },
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data['data'][index]['images']['fixed_height']
                    ['url'],
                fit: BoxFit.cover,
              ));
        } else {
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 70,
                  ),
                  Text('Load more')
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
