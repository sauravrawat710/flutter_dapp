import 'package:flutter/material.dart';

import 'package:flutter_dapp/widgets/audio_player_widget.dart';
import 'package:flutter_dapp/widgets/image_widget.dart';
import 'package:flutter_dapp/widgets/unsuported_widget.dart';
import 'package:flutter_dapp/widgets/video_player_widget.dart';

Widget buildWidget(String fileType, String contentID, String fileName) {
  List _supportVideoFormat = [
    'mp4',
    'm4a',
    'fmp4',
    'webm',
    'matroska',
  ];
  List _supportAudioFormat = [
    '3gp',
    'mp3',
    'aac',
    'ogg',
    'wav',
  ];
  List _supportImageFormat = [
    'jpeg',
    'jpg',
    'png',
    'gif',
    'webp',
    'wbmp',
  ];

  if (_supportVideoFormat.contains(fileType)) {
    return VideoPlayerWidget(contentID: contentID, fileName: fileName);
  }
  if (_supportAudioFormat.contains(fileType)) {
    return AudioPlayerWidget(contentID: contentID, fileName: fileName);
  }
  if (_supportImageFormat.contains(fileType)) {
    return ImageWidget(contentID: contentID, fileName: fileName);
  } else
    return UnSupportedWidget(contentID: contentID, fileName: fileName);
}
