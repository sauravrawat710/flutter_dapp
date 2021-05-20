import 'package:flutter/material.dart';
import 'package:flutter_dapp/services/api.dart';

class UnSupportedWidget extends StatelessWidget {
  final String contentID;
  final String fileName;

  const UnSupportedWidget({Key key, this.contentID, this.fileName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (fileName != null)
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Unsupported file format!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => Api().downloadFile(contentID, fileName),
                icon: Icon(Icons.download_rounded),
                label: Text('Download'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
