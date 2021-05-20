import 'package:flutter/material.dart';

import 'package:filesize/filesize.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/screens/detail_screen.dart';
import 'package:hive/hive.dart';

class UploadTile extends StatelessWidget {
  final AppResponseModel responseModel;
  final Box<AppResponseModel> box;
  const UploadTile({Key key, this.responseModel, this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      child: Dismissible(
        key: Key(responseModel.contentId),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('This action will delete your data!'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.black),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          box.delete(responseModel.contentId);
        },
        background: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white, size: 35),
              const SizedBox(width: 16),
            ],
          ),
        ),
        child: Card(
          child: ExpansionTile(
            title: Text(responseModel.name),
            children: [
              ListTile(
                title: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(
                      ClipboardData(text: responseModel.contentId),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Copied to Clipboard"),
                      ),
                    );
                  },
                  onTap: () => Navigator.of(context)
                      .pushNamed(DetailScreen.routeName, arguments: {
                    'name': responseModel.name,
                    'contentID': responseModel.contentId,
                    'fileType': responseModel.fileType,
                  }),
                  child: Text(
                    responseModel.contentId,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${responseModel.fileType} format'),
                    Text(filesize(responseModel.size)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
