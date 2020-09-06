import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var request = await HttpClient()
                  .getUrl(Uri.parse(_gifData['images']['fixed_height']['url']));
              var response = await request.close();
              Uint8List bytes =
                  await consolidateHttpClientResponseBytes(response);
              await Share.file(_gifData['title'], '${_gifData['id']}.gif',
                  bytes, 'image/gif',
                  text: '${_gifData['title']} by Awesome Gifs');
            },
          )
        ],
        title: Text(_gifData['title']),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData['images']['fixed_height']['url']),
      ),
    );
  }
}
