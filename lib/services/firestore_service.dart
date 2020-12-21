
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FiretoreService extends ChangeNotifier {
  String collectionName = 'songs';
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Song>> fetSongsAsStream() {
    return _db
        .collection(collectionName)
        .where('uid', isEqualTo: AuthService().getCurrentUser().uid)
        // .orderBy('updatedAt')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());
  }

  Future<List<Song>> fetchAllSongs() async {
    var result = await _db
        .collection(collectionName)
        .where('uid', isEqualTo: AuthService().getCurrentUser().uid)
        .get();
    List<Song> songs =
        result.docs.map((doc) => Song.fromJson(doc.data())).toList();
    return songs;
  }

  //Upsert
  Future<void> setSong(Song song) async {
    var options = SetOptions(merge: true);
    await _db
        .collection(collectionName)
        .doc(song.songId)
        .set(song.toJson(), options);
  }

  //Delete
  Future<void> removeSong(String songId) async {
    _db.collection(collectionName).doc(songId).delete();
  }
}
