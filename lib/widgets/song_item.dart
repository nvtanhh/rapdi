import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/screens/song_writer.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/material.dart';

class SongItem extends StatefulWidget {
  final Song song;

  const SongItem({Key key, this.song}) : super(key: key);

  @override
  _SongItemState createState() => _SongItemState(song);
}

class _SongItemState extends State<SongItem> {
  final Song song;

  _SongItemState(this.song);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
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
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
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
                    Divider(
                      color: AppTheme.holderColor.withOpacity(.5),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var songTitle =
      TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold);
  var songContentTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      letterSpacing: 0.4,
      height: 1.3,
      color: Colors.black45);

  _refresh() {
    Future.delayed(Duration.zero, () => setState(() {}));
  }
}
