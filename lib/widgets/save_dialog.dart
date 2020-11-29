import 'dart:io';
import 'dart:math';
import 'package:Rapdi/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// ignore: must_be_immutable
class SaveDialog extends StatefulWidget {
  // The SaveDialog will take the [defaultAudioFile] as input and rename it
  // with a new filename based on [dialogText] if the user presses the "Save" button.
  // If [doLookupLargestIndex] is true, the default new file filename will be
  // automatically numbered based on files already in the appDocumentsDirectory.

  final File defaultAudioFile;
  final String dialogText;
  final bool doLookupLargestIndex;
  final String songId;
  String newFilePath;

  SaveDialog(
      {Key key,
      this.defaultAudioFile,
      this.dialogText = 'null',
      this.doLookupLargestIndex = true,
      this.songId})
      : super(key: key);

  @override
  SaveDialogState createState() {
    SaveDialogState sDialog =
        SaveDialogState(defaultAudioFile, dialogText, doLookupLargestIndex);
    // Pass along the newFilePath obtained by SaveDialogState
    newFilePath = sDialog.newFilePath;
    return sDialog;
  }
}

class SaveDialogState extends State<SaveDialog> {
  File defaultAudioFile;
  String dialogText;
  String newFilePath;
  TextEditingController _textController;
  bool doLookupLargestIndex;

  SaveDialogState(
      this.defaultAudioFile, this.dialogText, this.doLookupLargestIndex);

  @override
  initState() {
    super.initState();
    initTextController(true);
  }

  @override
  dispose() {
    super.dispose();
    this._textController.dispose();
  }

  initTextController(bool doRebuildTextController) {
    if (doLookupLargestIndex) {
      initTextControllerWithLargestFileName(
          doRebuildTextController: doRebuildTextController);
    } else {
      initTextControllerWithCurrentFileName(
          doRebuildTextController: doRebuildTextController);
    }
  }

  Future<Null> initTextControllerWithCurrentFileName(
      {bool doRebuildTextController = true}) async {
    setState(() {
      this.newFilePath = defaultAudioFile.path;
      String defaultFileName =
          defaultAudioFile.path.split('/').last.split('.').first;
      if (doRebuildTextController) {
        this._textController = TextEditingController(text: defaultFileName);
      }
    });
  }

  Future<Null> initTextControllerWithLargestFileName(
      {bool doRebuildTextController = true}) async {
    Directory directory = await getApplicationDocumentsDirectory();

    String fname = await _largestNumberedFilename();
    print("new $fname");
    String fpath = p.join(directory.path, fname + '.m4a');
    setState(() {
      this.newFilePath = fpath;
      if (doRebuildTextController) {
        this._textController = TextEditingController(text: fname);
      }
    });
  }

  void _renameAudioFile() async {
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    Directory _appDocDirFolder;

    if (widget.songId != null) {
      String songId = widget.songId;
      _appDocDirFolder = Directory('${_appDocDir.path}/song$songId');
      if (!await _appDocDirFolder.exists()) {
        // check if not exist => create first
        _appDocDirFolder.create(recursive: true);
      }
    } else
      _appDocDirFolder = Directory('${_appDocDir.path}');

    newFilePath = p.join(_appDocDirFolder.path,
        _textController.text + '.m4a'); // dir/song1/demo1
    if (defaultAudioFile != null && newFilePath != null) {
      try {
        print("New file path $newFilePath");
        defaultAudioFile.rename(newFilePath);
        // Do not call initTextControllerState here!
      } catch (e) {
        if (await defaultAudioFile.exists()) {
          //FIXME: add file already exists warning
          print("File $defaultAudioFile already exists");
        } else {
          print('Error renaming file');
        }
      }
    } else {
      print("File $defaultAudioFile is null!");
    }
    // Close the save dialog and return a newFilePath which can be passed to
    // the Widget that called showDialog() <Does this really work>?
    Navigator.pop(context, File(newFilePath)); // what does this do?
  }

  Future<String> _largestNumberedFilename(
      {String filenamePrefix: "Demo-", String delimiter: "-"}) async {
    // Get the largest numbered filename with a given [filenamePrefix] and [delimiter]
    // from the ApplicationDocumentsDirectory
    bool isNumeric(String s) {
      //Helper method. See https://stackoverflow.com/questions/24085385/
      if (s == null) {
        return false;
      }
      // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
      return double.parse(s, (e) => null) != null ||
          int.parse(s, onError: (e) => null) != null;
    }

    try {
      String songId = widget.songId;
      String subDir = songId == null ? '' : 'song$songId';
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder =
          Directory('${_appDocDir.path}/$subDir/');
      if (!await _appDocDirFolder.exists()) {
        // check if not exist => create first
        await _appDocDirFolder.create(recursive: true);
      }

      // Directory directory = await getApplicationDocumentsDirectory();
      int largestInt = 0;
      print("$_appDocDirFolder");
      List<FileSystemEntity> entities = _appDocDirFolder.listSync();
      for (FileSystemEntity entity in entities) {
        String filePath = entity.path;
        if (filePath.endsWith('.m4a') && !(filePath.startsWith('Temp'))) {
          String bname = p.basename(filePath);
          if (bname.startsWith(filenamePrefix)) {
            final String noExt = bname.split('.')[0];
            String strIndex = noExt.split(delimiter).last;
            if (isNumeric(strIndex)) {
              int curInt = int.parse(strIndex);
              largestInt = max(largestInt, curInt);
            }
          }
        }
      }

      largestInt += 1;
      print("Found largest index $largestInt");
      return filenamePrefix + largestInt.toString();
    } catch (e) {
      print(
          "Error, failed to get documents directory and calculate largest numbered filename");
      return "1234";
    }
  }

  _deleteCurrentFile() async {
    //Clear the default audio file and reset query save and recording buttons
    if (defaultAudioFile != null) {
      defaultAudioFile.delete();
    } else {
      print("Error! defaultAudioFile is $defaultAudioFile");
    }
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    //FIXME: This should be done with a SharedAudioFile context
    print("Building");
    return AlertDialog(
        title: Text(dialogText),
        content: TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: "Tên demo:",
            hintText: "",
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "Bạn phải nhập tên cho demo này";
            } else
              return '';
          },
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text("Xoá"),
              onPressed: () =>
                  _deleteCurrentFile() //return null (File) to the Widget that called showDialog
              ),
          new FlatButton(
              child: const Text(
                "Lưu",
                style: TextStyle(color: AppTheme.accentColor),
              ),
              onPressed: () => _renameAudioFile())
        ]);
  }
}
