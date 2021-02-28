import 'dart:io';

import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/screens/song_writer.dart';
import 'package:Rapdi/services/firestore_service.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/search_bar/custom_search_bar.dart';
import 'package:Rapdi/widgets/search_bar/search_bar_style.dart';
import 'package:Rapdi/widgets/no_result_found.dart';
import 'package:Rapdi/widgets/song_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class SongsManager extends StatefulWidget {
  SongsManager({
    Key key,
  }) : super(key: key);

  @override
  _SongsManagerState createState() => _SongsManagerState();
}

class _SongsManagerState extends State<SongsManager> {
  List<Song> _songs;

  final FiretoreService firestoreService = FiretoreService();

  @override
  void initState() {
    getAllSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<FiretoreService>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: _getSearchBarUI(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Song newSong = Song.empty();
          await songProvider.setSong(newSong); // create new song in firebase
          setState(() {
            _songs.add(newSong);
            sortByTime(_songs);
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SongWriter(
                        song: newSong,
                        notifyParent: _refresh,
                      )));
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  getAppBarUI() {
    return Container(
        padding: const EdgeInsets.only(left: 18, right: 18),
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(child: Text('Tác phẩm', style: AppTheme.largeTitle)),
          ],
        ));
  }

  Future<List<Song>> _search(String search) async {
    return _songs
        .where(
            (song) => song.lyric.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Widget _getSearchBarUI() {
    return SearchBar<Song>(
      searchBarPadding: EdgeInsets.only(left: 18, right: 18),
      searchBarStyle: SearchBarStyle(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      listPadding: EdgeInsets.symmetric(horizontal: 3),
      placeHolder: _getSongsContent(),
      loader: Center(
        child: CircularProgressIndicator(), // Activity Indicator
      ),
      emptyWidget: NoResultFound(
        mess: 'Không có tác phẩm nào phù hợp!',
      ),
      hintText: "Tìm kiếm bằng lyrics",
      hintStyle: TextStyle(
        fontSize: 17,
        color: AppTheme.holderColor,
      ),
      textStyle: TextStyle(
        fontSize: 17,
        color: Colors.black,
      ),
      onSearch: _search,
      onRefreshed: _onRefresh,
      onItemFound: (Song song, int index) {
        return SongItem(
          song: song,
          onDelete: () => _deleteSong(index),
        );
      },
    );
  }

  Widget _getSongsContent() {
    if (_songs == null) {
      return Center(child: CircularProgressIndicator());
    } else if (_songs.length != 0) {
      return ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (BuildContext context, int index) {
          return SongItem(
            key: ObjectKey(_songs[index]),
            song: _songs[index],
            onDelete: () => _deleteSong(index),
          );
        },
      );
    } else
      return Center(
        child: NoResultFound(
          mess: 'Bạn chưa có tác phẩm nào cả',
          url: 'assets/images/no_demo.svg',
        ),
      );
  }

  Future<void> getAllSong() async {
    setState(() {
      _songs = null; // UI effect
    });
    await Future.delayed(Duration(milliseconds: 500));
    List<Song> songs;

    songs = await firestoreService.fetchAllSongs();

    sortByTime(songs);
    setState(() {
      _songs = songs;
    });
  }

  _onRefresh() {
    print('refresh...');
    getAllSong();
  }

  List<Song> sortByTime(List<Song> results) {
    if (results == null) return results;
    results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return results;
  }

  _refresh() {
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  void _deleteSong(int index) async {
    print("_deleteSong " + index.toString());
    var songId = _songs[index].songId;
    FiretoreService().removeSong(songId);
    //  delete record folder
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/song$songId/');
    if (await _appDocDirFolder.exists()) {
      await _appDocDirFolder.delete();
    }
    setState(() {
      _songs.removeAt(index);
    });
    Utils.showToast("Đã xoá");
  }
}
