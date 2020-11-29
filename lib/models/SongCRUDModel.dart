import 'package:Rapdi/locator.dart';
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SongCRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();
  List<Song> songs;

  Future<List<Song>> fetchSongs() async {
    var result = await _api.getDataCollection();
    songs = result.docs.map((doc) => Song.fromJson(doc.data())).toList();
    return songs;
  }

  Stream<QuerySnapshot> fetchSongsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Song> getSongById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Song.fromJson(doc.data());
  }

  Future removeSong(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateSong(Song data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addSong(Song song) async {
    var result = await _api.addDocument(song.toJson());
    return;
  }
}
