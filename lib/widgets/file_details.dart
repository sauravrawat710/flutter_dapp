import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filesize/filesize.dart';

import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/screens/fetch_screen.dart';

class FileDetails extends StatelessWidget {
  final AppResponseModel response;

  const FileDetails({Key key, this.response}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                response.name,
              ),
              Text(
                "File Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                response.fileType,
              ),
              Row(
                children: [
                  Text(
                    "Content ID",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: response.contentId),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Copied to Clipboard"),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy_outlined,
                    ),
                  ),
                ],
              ),
              Text(response.contentId),
              Text(
                "Size",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              response.size == '-' ? Text('-') : Text(filesize(response.size)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(FetchScreen.routeName),
          child: Text('Download By Content ID'),
        ),
      ],
    );
  }
}
