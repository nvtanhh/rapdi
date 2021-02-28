import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/screens/song_writer.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../app_theme.dart';

class SongItem extends StatefulWidget {
  final Song song;

  final VoidCallback onDelete;

  const SongItem({Key key, this.song, this.onDelete}) : super(key: key);

  @override
  _SongItemState createState() => _SongItemState(song);
}

class _SongItemState extends State<SongItem> {
  final Song song;

  _SongItemState(this.song);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: AppTheme.darkRed,
          icon: Icons.delete,
          onTap: _showDeleteDialog,
        ),
      ],
      child: Container(
        padding: EdgeInsets.fromLTRB(21, 15, 21, 0),
        child: InkWell(
          onLongPress: () {},
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SongWriter(
                          song: song,
                          notifyParent: _refresh,
                        )));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    Utils.getTimeAgo(song.updatedAt),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          song.title ?? 'Không tên',
                          style: songTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          song.lyric ?? '',
                          style: songContentTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(height: 1)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showSnackBar(BuildContext context, String text) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  // }

  var songTitle =
      TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold);
  var songContentTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      letterSpacing: 0.4,
      height: 1.3,
      color: Colors.black45);

  _refresh() {
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          title: Text("Xoá " + song.title + "?"),
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
                Navigator.of(context, rootNavigator: true).pop();
                if (widget.onDelete != null) widget.onDelete();
                print('XOÁ:  ' + widget.onDelete.toString());
              },
            ),
          ]),
    );
  }
}
