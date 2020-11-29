import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }

class DemoPlayer extends StatefulWidget {
  final File file;

  final Color color;

  const DemoPlayer({Key key, @required this.file, this.color})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(file);
}

class _HomePageState extends State<DemoPlayer> with WidgetsBindingObserver{
  File file;

  _HomePageState(this.file);

  PlayerState playerState = PlayerState.stopped;

  AudioPlayer _audioPlayer;

  // bool isPlaying = false;
  Duration position;
  Duration duration; // full duration of the file

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  StreamSubscription _audioPlayerCompletionSubscription;
  StreamSubscription _audioPlayerDurationSubscription;

  bool isSeeking = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    _audioPlayerCompletionSubscription.cancel();
    _audioPlayerDurationSubscription.cancel();
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("change lifecycle");
    switch (state) {
      case AppLifecycleState.inactive:
        print('inactive');
        _pause();
        break;
      case AppLifecycleState.paused:
        print('paused');
        _pause();
        break;
      case AppLifecycleState.resumed:
        print('resume');
        break;
      case AppLifecycleState.detached:
        print('detached');
        _pause();
        break;
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _audioPlayer = AudioPlayer();

    Future.delayed(Duration.zero, () async {
      await _audioPlayer.setUrl(file.path);
    });

    _audioPlayerCompletionSubscription = _audioPlayer.onPlayerCompletion
        .listen((p) => setState(() => playerState = PlayerState.stopped));

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });

    _audioPlayerDurationSubscription =
        _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    _audioPlayerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() {
          playerState = PlayerState.playing;
        });
      } else if (s == AudioPlayerState.STOPPED) {
        setState(() {
          playerState = PlayerState.stopped;
        });
      }
    }, onError: (msg) {
      setState(() {
        print("Error in subscription to audioPlayerState");
        print(msg);
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerCompletion
        .listen((p) => setState(() => playerState = PlayerState.stopped));


    _play();
  }

  void finishedMovedSlider(double value) {
    value = max(0, value);
    _audioPlayer.pause();
    position = new Duration(milliseconds: value.toInt());
    try {
      _audioPlayer.seek(position);
    } catch (e) {
      print("Error attempting to seek to time");
    }
    setState(() {
      playerState = PlayerState.paused;
    });
  }

  void movedSlider(double value) {
    // Update the slider image
    //value is in milliseconds
    if (value.toInt() % 100 == 0) {
      setState(() {
        position = new Duration(milliseconds: value.toInt());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the filename
          Text(
            file.path.split('/').last.split('.').first, // get file's name
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaleFactor: 1.5,
          ),
          //slider
          Visibility(
            visible: true,
            child: new Slider(
              onChangeStart: (v) {
                isSeeking = true;
              },
              onChanged: (value) {
                setState(() {
                  position =
                      Duration(seconds: (duration.inSeconds * value).round());
                });
                _play(position: position);
              },
              onChangeEnd: (value) {
                setState(() {
                  position =
                      Duration(seconds: (duration.inSeconds * value).round());
                });
                _audioPlayer.seek(position);
              },
              value: (position != null &&
                      duration != null &&
                      position.inSeconds > 0 &&
                      position.inSeconds < duration.inSeconds)
                  ? position.inSeconds / duration.inSeconds
                  : 0.0,
              activeColor: widget.color,
            ),
          ),
          Visibility(
            visible: true,
            child: new Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: _timer(context),
            ),
          ),
          Container(height: 10.0),
          // Display the audio control buttons
          ClipOval(
              child: Container(
            color: widget.color.withAlpha(30),
            width: 70.0,
            height: 70.0,
            child: IconButton(
              onPressed: () {
                isPlaying ? _pause() : _play();
              },
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30.0,
                color: widget.color,
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _formatDuration(position),
          style: style,
        ),
        new Text(
          _formatDuration(duration),
          style: style,
        ),
      ],
    );
  }

  Future stop() async {
    print("Pressed stop");
    await _audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  _pause() async {
    print("Pressed pause");
    await _audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  _play({Duration position}) async {
    Duration playPosition;
    if (position != null)
      playPosition = position;
    else {
      playPosition = (position != null &&
              duration != null &&
              position.inMilliseconds > 0 &&
              position.inMilliseconds < duration.inMilliseconds)
          ? position
          : null;
    }
    final result = await _audioPlayer.play(file.path,
        isLocal: true, position: playPosition);
    if (result == 1) setState(() => playerState = PlayerState.playing);
  }
}
