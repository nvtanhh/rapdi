import 'package:Rapdi/services/auth.dart';
import 'package:uuid/uuid.dart';

class Song {
  String userId;
  String songId;
  String title;
  String lyric;
  DateTime updatedAt;
  var uuid = Uuid();

  Song({this.userId, this.songId, this.title, this.lyric, this.updatedAt});

  factory Song.fromJson(Map<String, dynamic> json) => Song(
      userId: json['uid'],
      songId: json["id"].toString(),
      title: json["title"],
      lyric: json["lyric"],
      updatedAt: DateTime.parse(json["updatedAt"]));

  Map<String, dynamic> toJson() => {
        'uid': userId,
        'id': songId,
        'title': title,
        'lyric': lyric,
        'updatedAt': updatedAt.toIso8601String()
      };

  Song.empty({String suffix}) {
    userId = AuthService().getCurrentUser().uid;
    songId = uuid.v1();
    title = '';
    lyric = '';
    updatedAt = new DateTime.now();
  }

  @override
  String toString() {
    return 'Song{id: $songId, title: $title, lyric: $lyric, createdAt: $updatedAt}';
  }
}
