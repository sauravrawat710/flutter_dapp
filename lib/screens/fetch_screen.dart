import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/services/api.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

class FetchScreen extends StatefulWidget {
  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  bool _clicked = false;
  final Api api = Api();
  File response;
  String labelText = 'Enter Your CID';
  TextEditingController textEditingController;
  final String baseUrl = 'https://ipfs.infura.io/ipfs/';
  String downloadCount;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> getData(String hash) async {
    FocusScope.of(context).unfocus();
    if (hash.length == 46 || hash.substring(0, 1) == 'Qm') {
      setState(() {
        labelText = 'CID VERSION 0';
      });
    } else {
      setState(() {
        labelText = 'CID VERSION 1';
      });
    }
    setState(() {
      _clicked = true;
    });
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      String savePath = '${dir.path}/downloadedFromIPFS.jpg';
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          setState(() {
            downloadCount = ((count / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
      await ImageGallerySaver.saveFile(savePath);
    } catch (e) {
      throw e;
    }
    setState(() {
      downloadCount = 'Completed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => getData(textEditingController.text),
                child: Text('Search'),
              ),
              const SizedBox(height: 20),
              if (_clicked)
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            baseUrl + textEditingController.text,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () async => await downloadFile(
                          baseUrl + textEditingController.text),
                      icon: Icon(Icons.download_outlined),
                      label: Text('Download'),
                    ),
                    if (downloadCount != null)
                      Text(
                        'Downloading $downloadCount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
