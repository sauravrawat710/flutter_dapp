import 'dart:io';

import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:dio/dio.dart';

class Api {
  final String addUrl = 'https://ipfs.infura.io:5001/api/v0/add';
  // final String getUrl = 'https://ipfs.infura.io:5001/api/v0/get';
  final String getUrl = 'https://ipfs.infura.io/ipfs/';
  var dio = Dio();
  AppResponseModel appResponseModel;

  Future<AppResponseModel> addData(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        'path': await MultipartFile.fromFile(file.path, filename: fileName),
      },
    );
    try {
      Response response = await dio.post(addUrl, data: formData);
      if (response.statusCode == 200) {
        var data = response.data;
        return appResponseModel = AppResponseModel(
          name: data['Name'],
          hash: data['Hash'],
          size: data['Size'],
        );
      } else {
        return appResponseModel = AppResponseModel(
          name: 'Not Found',
          hash: 'Not Found',
          size: 'Not Found',
        );
      }
    } catch (e) {
      throw e;
    }
  }
}
