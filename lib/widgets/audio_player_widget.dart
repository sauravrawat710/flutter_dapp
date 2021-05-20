import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/constants.dart';
import 'package:flutter_dapp/services/api.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String contentID;
  final String fileName;

  const AudioPlayerWidget({Key key, this.contentID, this.fileName})
      : super(key: key);
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final String baseUrl = Constants.baseURL;
  bool _playing = false;

  Future<void> playAudio() async {
    await audioPlayer.play(
      baseUrl + widget.contentID,
      volume: 0.2,
    );
    setState(() {
      _playing = true;
    });
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      _playing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.fileName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 60,
                  ),
                  onPressed: () {
                    if (_playing) {
                      pauseAudio();
                    } else {
                      playAudio();
                    }
                  },
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  Api().downloadFile(widget.contentID, widget.fileName),
              icon: Icon(Icons.download_rounded),
              label: Text('Download'),
            ),
          ],
        ),
      ),
    );
  }
}
