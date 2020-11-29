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
import 'package:provider/provider.dart';

class SongsManager extends StatefulWidget {
  SongsManager({
    Key key,
  }) : super(key: key);

  @override
  _SongsManagerState createState() => _SongsManagerState();
}

class _SongsManagerState extends State<SongsManager> {
  // List<Song> _songs;

  // final FiretoreService firestoreService = FiretoreService();

  @override
  void initState() {
    // getAllSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<FiretoreService>(context);
    return Scaffold(
      body: StreamBuilder(
          stream: songProvider.fetSongsAsStream(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  getAppBarUI(),
                  Expanded(
                    child: _getSearchBarUI(sortByTime(snapshot.data)),
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Song newSong = Song.empty(suffix: Utils.currentDateTime());
          await songProvider.setSong(newSong); // create new song in firebase
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SongWriter(song: newSong)));
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
        // color: Colors.red,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(child: Text('Tác phẩm', style: AppTheme.largeTitle)),
          ],
        ));
  }

  Future<List<Song>> _search(String search) async {
    // return _songs
    //     .where(
    //         (song) => song.lyric.toLowerCase().contains(search.toLowerCase()))
    //     .toList();
  }

  Widget _getSearchBarUI(List<Song> songs) {
    return SearchBar<Song>(
      searchBarStyle: SearchBarStyle(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      listPadding: EdgeInsets.symmetric(horizontal: 3),
      placeHolder: _getSongsContent(songs),
      loader: Center(
        child: CircularProgressIndicator(), // Activity Indicator
      ),
      emptyWidget: NoResultFound(mess: 'Không có tác phẩm nào phù hợp!'),
      hintText: "Search by lyrics",
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
        return SongItem(song: song);
      },
    );
  }

  Widget _getSongsContent(List<Song> songs) {
    if (songs == null) {
      return Center(child: CircularProgressIndicator());
    } else if (songs.length != 0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int index) {
            return SongItem(song: songs[index]);
          },
        ),
      );
    } else
      return Center(child: Text('Empty!!!'));
  }

  Future<void> getAllSong() async {
    // setState(() {
    //   _songs = null; // UI effect
    // });
    // await Future.delayed(Duration(milliseconds: 500));
    // List<Song> songs;
    //
    // songs = await firestoreService.fetchAllSongs();
    // sortByTime(songs);
    // setState(() {
    //   _songs = songs;
    // });
    // print(_songs);
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
}
