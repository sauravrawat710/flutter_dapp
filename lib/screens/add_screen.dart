import 'dart:io';
// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/services/api.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool _isLoading = false;
  File _image;
  ImagePicker imagePicker = ImagePicker();
  Api api = Api();
  AppResponseModel response;

  Future<void> pickFile() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _image = File(pickedFile.path);
      });
      response = await api.addData(_image);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_image != null)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('${_image.path.split('/').last} Selected!'),
                ),
              const SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: pickFile,
                      child: Text('Click to Upload'),
                    ),
              const SizedBox(height: 10),
              if (response != null)
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
                      Row(
                        children: [
                          Text(
                            "Hash",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  new ClipboardData(text: response.hash));
                              ScaffoldMessenger.of(context).showSnackBar(
                                new SnackBar(
                                  content: new Text("Copied to Clipboard"),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy_outlined,
                            ),
                          ),
                        ],
                      ),
                      Text(response.hash),
                      Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${response.size} KB"),
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
