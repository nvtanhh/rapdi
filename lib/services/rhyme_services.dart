import 'dart:convert';

import 'package:Rapdi/models/RhymeSearchResults.dart';
import 'package:http/http.dart' as http;

class RhymesServices {
  String findRhymesEndpoint = "https://rapdi-api.herokuapp.com/dict?words=";

  // https://rapdi-api.herokuapp.com/dict?words=dẫn đường

  String findFlashRhymesEndpoint =
      "https://rapdi-api.herokuapp.com/dict/flash?words=";

  // https://rapdi-api.herokuapp.com/dict/flash?words=dẫn đường

  Future<List<RhymeSearchResults>> findRhymes(String words) async {
    final response = await http.get(findRhymesEndpoint + words);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON return list Rhymes
      List jsonResponse = jsonDecode(response.body);
      return (jsonResponse).map((i) => RhymeSearchResults.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List<String>> findFlashRhymes(String words) async {
    final response = await http.get(findFlashRhymesEndpoint + words);
    if (response.statusCode == 200) {
      List<String> rs = new List<String>.from(jsonDecode(response.body));
      return rs;
    } else {
      return null;
    }
  }
}
