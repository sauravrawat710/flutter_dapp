import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/constants.dart';
import 'package:flutter_dapp/services/api.dart';

class FetchScreen extends StatefulWidget {
  static const String routeName = 'fetch/';
  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  bool _clicked = false;
  final Api api = Api();
  File response;
  String labelText = 'Enter Your CID';
  TextEditingController textEditingController;
  final String baseUrl = Constants.baseURL;
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
    setState(() {
      if (hash.length == 46 && hash.substring(0, 2) == 'Qm') {
        labelText = 'CID VERSION 0';
      } else {
        labelText = 'CID VERSION 1';
      }
      _clicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                key: Key(textEditingController.text),
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            OutlinedButton.icon(
              icon: Icon(Icons.search),
              onPressed: () => getData(textEditingController.text),
              label: Text('Search'),
            ),
            const SizedBox(height: 20),
            if (_clicked)
              Column(
                children: [
                  Text(
                    'No preview available!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Api().downloadFile(
                        textEditingController.text, textEditingController.text),
                    icon: Icon(Icons.download_outlined),
                    label: Text('Download'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
