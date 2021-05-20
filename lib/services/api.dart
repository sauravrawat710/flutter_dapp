import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_dapp/constants.dart';
import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Api {
  final String addUrl = Constants.addURl;
  var dio = Dio();
  AppResponseModel appResponseModel;

  Future<AppResponseModel> addData(
    File file,
    String fileName,
    String fileExtension,
  ) async {
    FormData formData = FormData.fromMap(
      {'path': await MultipartFile.fromFile(file.path, filename: fileName)},
    );
    try {
      Response response = await dio.post(addUrl, data: formData);
      if (response.statusCode == 200) {
        var data = response.data;
        var box = await Hive.openBox<AppResponseModel>('userUploaded');

        box.put(
          data['Hash'],
          AppResponseModel(
            name: data['Name'],
            fileType: fileExtension,
            contentId: data['Hash'],
            size: data['Size'],
          ),
        );
        return appResponseModel = AppResponseModel(
          name: data['Name'],
          fileType: fileExtension,
          contentId: data['Hash'],
          size: data['Size'],
        );
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<void> downloadFile(String contentID, String fileName) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          // var directory = await getExternalStorageDirectory();
          var directory = await DownloadsPathProvider.downloadsDirectory;
          print(directory);
          bool hasExisted = await directory.exists();

          if (!hasExisted) {
            directory.create(recursive: true);
          }
          String id = await FlutterDownloader.enqueue(
            url: Constants.baseURL + contentID,
            savedDir: directory.path,
            fileName: fileName,
            showNotification:
                true, // show download progress in status bar (for Android)
            openFileFromNotification:
                true, // click on notification to open downloaded file (for Android)
          );
          FlutterDownloader.open(taskId: id);
        } else {
          return false;
        }
        //code for ios...
        return;
      }
    } catch (e) {
      print(e);
    }
  }
}
