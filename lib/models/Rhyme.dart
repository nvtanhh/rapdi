class Rhyme {
  String value;
  Rhyme({this.value});

  static fromJson(String json) => Rhyme(value: json);

  @override
  String toString() {
    return value.toString();
  }
}
