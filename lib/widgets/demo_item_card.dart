import 'dart:io';

import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/screens/demo_player.dart';
import 'package:Rapdi/widgets/save_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

class DemoItem extends StatefulWidget {
  final Function onDeleteFile;
  final String filePath;
  final String songId;

  DemoItem(
      {Key key,
      @required this.filePath,
      @required this.songId,
      @required this.onDeleteFile})
      : super(key: key);

  @override
  _DemoItemState createState() => _DemoItemState(filePath);
}

class _DemoItemState extends State<DemoItem> {
  RandomColor _randomColor = RandomColor();
  String filePath;

  String created;

  _DemoItemState(this.filePath);

  File file;
  String fileName;
  Color _color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFileAttributes();
    _color = _randomColor.randomColor(
        colorHue: ColorHue.blue, colorBrightness: ColorBrightness.dark);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initFileAttributes() async {
    setState(() {
      file = File(filePath);
      fileName = filePath.split("/").last.split('.').first;
    });
    DateTime time = file.lastModifiedSync();
    created = DateFormat('yyyy-MM-dd H:m').format(time);
  }

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return Container(
        child: Text('null '),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: ListTile(
          onLongPress: () {},
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
                builder: (BuildContext context) {
                  return DemoPlayer(
                    file: file,
                    color: _color,
                  );
                });
          },
          dense: true,
          // contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
          trailing: createTrailingButtons(),
          title: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/default_song.png')),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        fileName,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: _color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          //   Text(
                          //     '00:08',
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // SizedBox(width: 7),
                          Text(
                            created,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showPopupMenu() async {
    Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 100,
      width: 100,
      child: PopupMenuButton(
        child: FlutterLogo(),
        itemBuilder: (context) {
          return <PopupMenuItem>[new PopupMenuItem(child: Text('Delete'))];
        },
      ),
    );
  }

  Widget createTrailingButtons() {
    // Note: https://stackoverflow.com/questions/44656013
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      // height: 100,
      // width: 100,
      child: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          padding: EdgeInsets.zero,
          onSelected: (value) {
            switch (value) {
              case 'rename':
                _showRenameDialog();

                break;
              case 'delete':
                showDialog(
                  context: context,
                  builder: (_) => _openQueryDeleteDialog(),
                );

                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  textStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  value: 'rename',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.black45, size: 18),
                      SizedBox(width: 10),
                      Text('Rename')
                    ],
                  ),
                ),

                // ignore: list_element_type_not_assignable, https://github.com/flutter/flutter/issues/5771
                PopupMenuItem<String>(
                  textStyle: TextStyle(fontSize: 15, color: Colors.black45),
                  value: 'delete',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: Colors.black45, size: 18),
                      SizedBox(width: 10),
                      Text('Delete')
                    ],
                  ),
                )
              ]),
    );
  }

  AlertDialog _openQueryDeleteDialog() {
    return AlertDialog(title: Text("Xoá " + fileName + "?"),
        actions: <Widget>[
          new FlatButton(
              child: const Text("HUỶ"),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop()),
          new FlatButton(
            child: const Text(
              "XOÁ",
              style: TextStyle(color: AppTheme.accentColor),
            ),
            onPressed: () {
              widget.onDeleteFile(filePath);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ]);
  }

  _showRenameDialog() async {
    // Note: SaveDialog should return a File or null when calling Navigator.pop()
    // Catch this return value and update the state of the ListTile if the File has been renamed
    // Useful info on making Dialogs that update parents: https://stackoverflow.com/questions/49706046/
    File newFile = await showDialog(
        context: context,
        builder: (context) => SaveDialog(
              defaultAudioFile: file,
              dialogText: "Rename $fileName",
              doLookupLargestIndex: false,
              songId: widget.songId, //
            )); // note perhaps only showdialog should be asynced

    // The return type is actually a File due to the navigator pop statement!
    //debugger(message:"hello");
    // Update the ListTile filename once the dialog is closed
    if (newFile != null) {
      filePath = newFile.path;
      initFileAttributes();
    }
  }

}
