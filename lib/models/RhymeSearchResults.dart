import 'package:Rapdi/models/Rhyme.dart';
import 'package:flutter/cupertino.dart';

class RhymeSearchResults {
  List<List<Rhyme>> rhymesBag;

  RhymeSearchResults({@required this.rhymesBag});

  factory RhymeSearchResults.fromJson(List json) {
    // var myBag =
    //     json.map((i) => i.map((j) => Rhyme.fromJson(j)).toList()).toList();
    // return RhymeSearchResults(
    //   rhymesBag: myBag,
    // );

    return RhymeSearchResults(
        rhymesBag: List.generate(
            json.length,
            (i) => (List<Rhyme>.from(
                json[i].map((j) => Rhyme.fromJson(j)).toList()))));
  }
}
