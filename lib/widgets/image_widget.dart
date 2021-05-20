import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dapp/constants.dart';
import 'package:flutter_dapp/services/api.dart';

class ImageWidget extends StatefulWidget {
  final String contentID;
  final String fileName;

  const ImageWidget({Key key, this.contentID, this.fileName}) : super(key: key);
  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String baseURL = Constants.baseURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 300,
            width: double.infinity,
            child: Card(
              elevation: 10,
              child: Image.network(
                baseURL + widget.contentID,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.fileName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                Api().downloadFile(widget.contentID, widget.fileName),
            icon: Icon(Icons.download_rounded),
            label: Text('Download'),
          ),
        ],
      ),
    );
  }
}
