import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/screens/add_screen.dart';
import 'package:flutter_dapp/screens/fetch_screen.dart';
import 'package:flutter_dapp/widgets/expandable_fab.dart';
import 'package:flutter_dapp/widgets/upload_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppResponseModel _responseModel;
  Box<AppResponseModel> box;

  Future<void> pickFile() async {
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      Navigator.of(context).pushNamed(
        AddScreen.routeName,
        arguments: {'pickedFile': pickedFile},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select file")),
      );
    }
  }

  @override
  void initState() {
    openDB();
    super.initState();
  }

  void openDB() async {
    box = await Hive.openBox<AppResponseModel>('userUploaded');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(width: 2),
            Text('DApp'),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        child: box != null
            ? ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<AppResponseModel> box, _) {
                  List<AppResponseModel> data = box.values.toList();
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      _responseModel = data[index];
                      return UploadTile(
                        responseModel: _responseModel,
                        box: box,
                      );
                    },
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: ExpandableFab(
        distance: 60.0,
        children: [
          ActionButton(
            icon: Icon(Icons.add),
            onPressed: pickFile,
          ),
          ActionButton(
            icon: Icon(Icons.file_download),
            onPressed: () =>
                Navigator.of(context).pushNamed(FetchScreen.routeName),
          ),
        ],
      ),
    );
  }
}
