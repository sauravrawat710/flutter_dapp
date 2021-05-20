import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/widgets/build_widget.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = 'detail/';
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String fileName;
  String contentID;
  String fileType;
  ReceivePort _receivePort = ReceivePort();

  static downloadingCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName('downloading');

    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloading');
    _receivePort.listen((message) {});
    FlutterDownloader.registerCallback(downloadingCallBack);
    runAtStart();
    super.initState();
  }

  void runAtStart() {
    Future.delayed(Duration.zero, () {
      Map<String, String> args =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      setState(() {
        fileName = args['name'];
        contentID = args['contentID'];
        fileType = args['fileType'];
      });
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloading');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fileName != null
          ? AppBar(
              title: Text(fileName),
              backgroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: Container(
        child: Center(
          child: buildWidget(fileType, contentID, fileName),
        ),
      ),
    );
  }
}
