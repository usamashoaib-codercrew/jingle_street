import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoPlaying = false;
  double _videoProgress = 0.0;
  String? _videoError;
  bool _showControls = false;

  @override
  void initState() {
    // _videoController = VideoPlayerController.network(widget.videoUrl);
    // _videoController = VideoPlayerController.file(File(widget.videoUrl));
    if (Uri.parse(widget.videoUrl).isScheme('http') || Uri.parse(widget.videoUrl).isScheme('https')) {
      _videoController = VideoPlayerController.network(widget.videoUrl);
    } else {
      _videoController = VideoPlayerController.file(File(widget.videoUrl));
    }
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      setState(() {});
      _videoController.play(); // Auto-play the video
      _isVideoPlaying = true;
    }).catchError((error) {
      setState(() {
        _videoError = 'Failed to load video: $error';
      });
    });
    _videoController.addListener(() {
      setState(() {
        _videoProgress = _videoController.value.position.inMilliseconds.toDouble();
      });
      if (_videoController.value.position >= _videoController.value.duration) {
        _videoController.seekTo(Duration.zero); // Restart the video when it reaches the end
        _videoController.pause();
        _isVideoPlaying = false;
      }
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    // Reset preferred orientations when disposing the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_isVideoPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  void _onVideoSliderChanged(double value) {
    setState(() {
      final Duration duration = _videoController.value.duration;
      final newPosition = value * duration.inMilliseconds.toDouble();
      _videoController.seekTo(Duration(milliseconds: newPosition.round()));
      _videoProgress = value;
    });
  }


  String _formatDuration(Duration duration) {
    final seconds = duration.inSeconds;
    final minutes = (seconds / 60).floor();
    final secondsRemainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsRemainder.toString().padLeft(2, '0')}';
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return WillPopScope(
      onWillPop: () async {
        // Reset preferred orientations when back button is pressed
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // Show the back button
          elevation: 0,
          backgroundColor: Colors.transparent, // Make the app bar transparent
        ),
        extendBodyBehindAppBar: true, // Extend body behind the app bar
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControlsVisibility,
          child: Stack(
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_videoError != null) {
                      return Center(
                        child: Text(
                          // _videoError!,
                          'Something went wrong. Please reload the page.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load video.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Visibility(
                visible: _showControls,
                child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Column(
                    children: [
                      Slider(
                        value: _videoProgress,
                        min: 0.0,
                        max: _videoController.value.duration.inMilliseconds.toDouble(),
                        onChanged: _onVideoSliderChanged,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _formatDuration(_videoController.value.position),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _formatDuration(_videoController.value.duration),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _showControls && !_isVideoPlaying,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 65,
                      ),
                      onPressed: _toggleVideoPlayback,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _showControls && _isVideoPlaying,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      icon: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 65,
                      ),
                      onPressed: _toggleVideoPlayback,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
