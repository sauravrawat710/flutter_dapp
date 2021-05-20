import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/services/api.dart';
import 'package:flutter_dapp/widgets/file_details.dart';
import 'package:shimmer/shimmer.dart';

@immutable
class AddScreen extends StatefulWidget {
  static const String routeName = 'add/';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File _data;
  FilePickerResult pickedFile;
  Api api = Api();
  Future<AppResponseModel> futureResponse;

  Future<AppResponseModel> addFile() {
    setState(() {
      _data = File(pickedFile.files.single.path);
    });
    String fileName = pickedFile.files.single.name;
    String fileExtension = pickedFile.files.first.path.split(".").last;
    return futureResponse = api.addData(_data, fileName, fileExtension);
  }

  @override
  void initState() {
    runAtStart();
    super.initState();
  }

  void runAtStart() {
    Future.delayed(Duration.zero, () {
      Map args = ModalRoute.of(context).settings.arguments
          as Map<String, FilePickerResult>;
      pickedFile = args['pickedFile'];
      futureResponse = addFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_data != null)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('${_data.path.split('/').last} Selected!'),
                ),
              const SizedBox(height: 10),
              FutureBuilder<AppResponseModel>(
                future: futureResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return FileDetails(response: snapshot.data);
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[400],
                      highlightColor: Color.fromRGBO(192, 192, 192, 0),
                      child: FileDetails(
                        response: AppResponseModel(
                          name: '-',
                          fileType: '-',
                          contentId: '-',
                          size: '-',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
