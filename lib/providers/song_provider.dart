import 'package:Rapdi/models/Song.dart';
import 'package:flutter/cupertino.dart';
import 'package:Rapdi/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class SongProvider extends ChangeNotifier {
  final FiretoreService firestoreService = FiretoreService();
  String _id;
  String _title;
  String _lyric;
  DateTime _createdAt;
  var uuid = Uuid();

  //Getters
  DateTime get createAt => _createdAt;

  String get entry => _title;

  String get lyric => _lyric;

  Stream<List<Song>> get songs => firestoreService.fetSongsAsStream();

  //Setters
  set updateTime(DateTime date) {
    _createdAt = date;
    notifyListeners();
  }

  set changeTitle(String newTitle) {
    _title = entry;
    notifyListeners();
  }

  set changeLyric(String newTitle) {
    _title = entry;
    notifyListeners();
  }

  //Functions
  loadSong(Song song) {
    if (song != null) {
      _id = song.songId;
      _title = song.title;
      _lyric = song.lyric;
      _createdAt = song.updatedAt;
    } else {
      _id = null;
      _title = null;
      _lyric = null;
      _createdAt = DateTime.now();
    }
  }

  Song saveSong() {
    if (_id == null) {
      //Add
      var newSong = Song(
          songId: uuid.v1(),
          title: 'Bài mới',
          lyric: '',
          updatedAt: DateTime.now());
      firestoreService.setSong(newSong);
      return newSong;
    } else {
      //Edit
      var updatedSong = Song(
          songId: uuid.v1(), title: _title, lyric: _lyric, updatedAt: _createdAt);
      firestoreService.setSong(updatedSong);
      return updatedSong;
    }
  }

  removeEntry(String songId) {
    firestoreService.removeSong(songId);
  }

  Future<List<Song>> fetchSongs() async {
    return await firestoreService.fetchAllSongs();
  }
}
