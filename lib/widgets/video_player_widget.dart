import 'package:flutter/material.dart';
import 'package:flutter_dapp/constants.dart';
import 'package:flutter_dapp/services/api.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String contentID;
  final String fileName;

  const VideoPlayerWidget({Key key, this.contentID, this.fileName})
      : super(key: key);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  String baseURL = Constants.baseURL;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _playing = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(baseURL + widget.contentID);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 500,
                    margin: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _playing = false;
                              _controller.pause();
                            } else {
                              _playing = true;
                              _controller.play();
                            }
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            children: [
                              VideoPlayer(_controller),
                              if (!_playing)
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.black45),
                                ),
                              if (!_playing)
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.fileName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Api().downloadFile(widget.contentID, widget.fileName),
                    icon: Icon(Icons.download_rounded),
                    label: Text('Download'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
