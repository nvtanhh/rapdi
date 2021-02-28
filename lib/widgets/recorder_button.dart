import 'dart:async';
import 'dart:io';

import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/save_dialog.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderButton extends StatefulWidget {
  final String songId;

  RecorderButton({this.songId});

  @override
  _RecorderButtonState createState() => _RecorderButtonState();
}

class _RecorderButtonState extends State<RecorderButton> {
  bool _isRecording = false;
  Timer _timer;
  int _start = 0;
  String timeText = '0';

  // Note: The following variables are not state variables.
  String tempFilename = "TempRecording"; //Filename without path or extension
  File defaultAudioFile;

  _stopRecording() async {
    print('call stop...!');

    // Await return of Recording object
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;

    //Directory docDir = await storage.docDir;
    Directory docDir = await getApplicationDocumentsDirectory();
    setState(() {
      //Tells flutter to rerun the build method
      _start = 0;
      _isRecording = isRecording;
      defaultAudioFile = File(p.join(docDir.path, this.tempFilename + '.m4a'));
    });

    // Show dialog to save file or delete file
    _showSaveDialog();
  }

  _startRecording() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        Directory docDir = await getApplicationDocumentsDirectory();

        String newFilePath = p.join(docDir.path, this.tempFilename);
        File tempAudioFile = File(newFilePath + '.m4a');
        // utils.showToast(('Recording...'));
        if (await tempAudioFile.exists()) {
          await tempAudioFile.delete();
        }
        await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.AAC);

        bool isRecording = await AudioRecorder.isRecording;
        print('File path: ' + newFilePath);
        _isRecording = isRecording;
        defaultAudioFile = tempAudioFile;
        startTimer();
      } else {
        Utils.showToast("You must accept permissions", time: 1);
        _requestPermissions();
      }
    } catch (e) {
      print(e);
    }
  }

  _showSaveDialog() async {
    // Note: SaveDialog should return a File or null when calling Navigator.pop()
    // Catch this return value and update the state of the ListTile if the File has been renamed
    File newFile = await showDialog(
      barrierDismissible: false, // prevent click outside the dialog
      context: context,
      builder: (context) => SaveDialog(
        dialogText: 'Bạn có muốn lưu demo này không?',
        defaultAudioFile: defaultAudioFile,
        songId: widget.songId,
      ),
    );

    if (newFile != null) {
      String basename = p.basename(newFile.path);
      Utils.showToast("Đã lưu $basename");
    } else {
      Utils.showToast("Đã xoá");
    }
    _isRecording = false;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (!_isRecording) {
            timer.cancel();
          } else {
            _start += 1;
            final now = Duration(seconds: _start);
            timeText = _printDuration(now);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: !_isRecording ? Colors.white : AppTheme.darkRed,
            boxShadow: [
              new BoxShadow(
                color: !_isRecording
                    ? AppTheme.accentColor.withOpacity(.3)
                    : AppTheme.darkRed.withOpacity(.3),
                blurRadius: 2, // soften the shadow
                spreadRadius: 1,
                offset: new Offset(1.0, 2.0),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: !_isRecording
                    ? [
                        Icon(Icons.circle, size: 20, color: AppTheme.darkRed),
                        SizedBox(width: 5),
                        Text('Ghi âm',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: AppTheme.darkRed,
                            )),
                      ]
                    : [
                        Icon(Icons.stop_rounded, size: 24, color: Colors.white),
                        SizedBox(width: 5),
                        Text(timeText,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: Colors.white))
                      ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void _requestPermissions() async {
  if (!await Permission.microphone.status.isGranted) {
    await Permission.microphone.request();
  }
  if (!await Permission.storage.status.isGranted) {
    await Permission.storage.request();
  }
}
