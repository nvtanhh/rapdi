import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/custom_icon_icons.dart';
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/screens/search_rhymes.dart';
import 'package:Rapdi/screens/song_demos.dart';
import 'package:Rapdi/services/firestore_service.dart';
import 'package:Rapdi/services/rhyme_services.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/jumping_dot.dart';
import 'package:Rapdi/widgets/recorder_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class SongWriter extends StatefulWidget {
  // final LocalFileSystem localFileSystem;
  final Song song;

  final Function notifyParent;

  SongWriter({song, this.notifyParent})
      : this.song = song ?? Song.empty(suffix: Utils.currentDateTime());

  @override
  _SongWriterState createState() => _SongWriterState();
}

class _SongWriterState extends State<SongWriter> {
  FiretoreService songProvider;

  // final _titleController = TextEditingController();
  String title;
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _lyricFocuses = [];
  List<TextEditingController> _lyricControllers = [];
  String suggestionWord = '';
  bool isKeyboardShowing = false;
  int currentIndex = -1;

  final evenPrefix = [
    'A',
    'A',
    'B',
    'B',
    'A',
    'A',
    'B',
    'B',
    'A',
    'A'
  ]; // 0 -> 9
  final oddPrefix = [
    'B',
    'B',
    'A',
    'A',
    'B',
    'B',
    'A',
    'A',
    'B',
    'B'
  ]; // 10 -> 19

  KeyboardVisibilityController keyboardVisibilityController;

  @override
  void initState() {
    super.initState();

    title = widget.song.title ?? '';
    generateLyrics();

    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (this.mounted)
        setState(() {
          isKeyboardShowing = visible;
        });
    });
  }

  @override
  void dispose() {
    saveAll();
    if (widget.notifyParent != null) widget.notifyParent();
    super.dispose();
  }

  Future<void> saveAll() async {
    widget.song.lyric = getLyrics();
    widget.song.title =
        title.isNotEmpty ? title : "Bài mới " + Utils.currentDateTime();
    widget.song.updatedAt = DateTime.now();
    await songProvider.setSong(widget.song);
  }

  String getLyrics() {
    String lyric = '';
    for (int i = 0; i < _lyricControllers.length; i++) {
      lyric += _lyricControllers[i].text.trim() + '\n';
    }
    return lyric.trim();
  }

  void generateLyrics() {
    if (widget.song.lyric == '') widget.song.lyric = ' ';
    // else if (widget.song.lyric[0] != ' ')
    //   widget.song.lyric = ' ' + widget.song.lyric; // if null init default value

    List<String> lines = widget.song.lyric.split('\n');
    for (int i = 0; i < lines.length; i++) {
      // generate first character for each line
      if (lines[i].isEmpty)
        lines[i] = ' ';
      else if (lines[i][0] != ' ') lines[i] = ' ' + lines[i];

      _lyricFocuses.add(FocusNode());
      _lyricControllers.add(TextEditingController(text: lines[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    songProvider = Provider.of<FiretoreService>(context);
    return Scaffold(
      appBar: _getAppBarUI(),
      body: _getEditAreaUI(),
    );
  }

  AppBar _getAppBarUI() {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      title: RecorderButton(songId: widget.song.songId),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 18),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SongDemo(songId: widget.song.songId)),
              );
            },
            child: Icon(CustomIcon.file_audio, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _getEditAreaUI() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _titleTextField(),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: List.generate(_lyricControllers.length,
                        (index) => _contentTextField(index))),
              ),
            ),
            if (isKeyboardShowing) _suggestionRhymesUI()
          ],
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        enableSuggestions: false,
        controller: TextEditingController()..text = title,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        cursorColor: AppTheme.primaryColor,
        // cursorHeight: 30,
        style: TextStyle(
            fontSize: 24,
            height: 1.2,
            color: Colors.black,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration.collapsed(
          hintText: "Nhập tên bài hát",
          hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(.2)),
        ),
        maxLines: 1,
        onChanged: (value) {
          title = value;
        },
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(_lyricFocuses[0]);
        },
      ),
    );
  }

  Widget _contentTextField(int index) {
    var prefix = getPrefix(index) + ' ';

    return Container(
      padding: EdgeInsets.only(top: 10, left: 18, right: 18),
      child: TextField(
        enableSuggestions: false,
        autocorrect: false,
        autofocus: false,
        // keyboardType: TextInputType.visiblePassword,
        // textInputAction: TextInputAction.none,
        controller: _lyricControllers[index],
        maxLines: null,
        focusNode: _lyricFocuses[index],
        textCapitalization: TextCapitalization.sentences,
        cursorColor: AppTheme.primaryColor,
        style: TextStyle(
          fontSize: 17,
          height: 1.5,
          color: Colors.black.withOpacity(.76),
        ),
        decoration: new InputDecoration(
            isCollapsed: true,
            prefixText: prefix,
            prefixStyle: TextStyle(fontSize: 13, color: AppTheme.accentColor),
            border: InputBorder.none),
        onChanged: (value) => _processOnChange(index, value),
        onTap: () {
          // print('tab ' + index.toString());
          detectSelectedText(_lyricControllers[index]);
        },
        // FocusScope.of(context).requestFocus(focus);
      ),
    );
  }

  bool isPressDelete(String value) {
    return value.isEmpty || value[0] != ' ';
  }

  _processOnChange(int index, String value) {
    print('_processOnChange');
    if (value.isEmpty && index >= 1) {
      // print('// press delete key');
      setState(() {
        _lyricControllers.removeAt(index);
        _lyricFocuses[index - 1].requestFocus();
        currentIndex = index - 1;
        _lyricFocuses.removeAt(index);
        suggestionWord = '';
      });

      if (index - 1 > 0) suggestRhymes(index - 1);
    } else if (value[0] != ' ' && index >= 1) {
      setState(() {
        _lyricControllers.removeAt(index);
        _lyricControllers[index - 1].text =
            _lyricControllers[index - 1].text + value;
        _lyricControllers[index - 1].selection = TextSelection.fromPosition(
            TextPosition(
                offset:
                    _lyricControllers[index - 1].text.length - value.length));

        _lyricFocuses[index - 1].requestFocus();
        currentIndex = index - 1;
        _lyricFocuses.removeAt(index);
      });
    } else {
      final values = value.split('\n');
      if (values.length > 1) {
        setState(() {
          _lyricControllers[index].text = values[0];
          // Fix origin textField position effect
          _lyricControllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _lyricControllers[index].text.length));

          _lyricControllers.insert(
              index + 1,
              TextEditingController(text: ' ' + values[1])
                ..selection =
                    TextSelection.fromPosition(TextPosition(offset: 1)));
          _lyricFocuses.insert(index + 1, FocusNode()..requestFocus());
          currentIndex = index + 1;
        });
        suggestRhymes(index + 1); // new line
      }
    }
  }

  String getPrefix(int index) {
    int soHangChuc = (index % 100) ~/ 10; // số ở hàng chục
    if (soHangChuc % 2 == 0)
      return evenPrefix[index % 10];
    else
      return oddPrefix[index % 10];
  }

  void suggestRhymes(int index) {
    var currentPrefix = getPrefix(index);
    for (int i = index - 1; i >= 0; i--) {
      String text = _lyricControllers[i].text;
      if (!isBlank(text)) {
        if (currentPrefix == getPrefix(i)) {
          setState(() {
            suggestionWord = getLast3Words(text);
          });

          print(suggestionWord);
          return;
        }
      }
    }
    setState(() {
      suggestionWord = '';
    });
  }

  bool isBlank(String s) {
    return s == null || s.trim() == '';
  }

  String getLast3Words(String text) {
    final splitter = text.trim().split(' ');
    if (splitter.length >= 3)
      return splitter[splitter.length - 3] +
          ' ' +
          splitter[splitter.length - 2] +
          ' ' +
          splitter[splitter.length - 1];
    else
      return text;
  }

  Widget _suggestionRhymesUI() {
    return Container(
      height: 35,
      child: FutureBuilder(
        future: findRhymes(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Row(
              children: [
                suggestionWord.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            var rhyme = snapshot.data[index];
                            return InkWell(
                              onTap: () {
                                var currentText =
                                    _lyricControllers[currentIndex].text;
                                _lyricControllers[currentIndex].text =
                                    currentText + " " + rhyme;
                                _lyricControllers[currentIndex].selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: currentText.length));
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5)),
                                child: Center(
                                    child: Text(rhyme,
                                        style: TextStyle(color: Colors.white))),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(),
                      ),
                _moreButton(suggestionWord),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Container(
                  child: JumpingDots(
                color: Theme.of(context).primaryColor,
              )),
            );
          return Container();
        },
      ),
    );
  }

  String getSelectionText(int index) {
    //   return _lyricControllers[index].text.substring(
    //       _lyricControllers[index].selection.baseOffset,
    //       _lyricControllers[index].selection.extentOffset);
    return _lyricControllers[index]
        .selection
        .textInside(_lyricControllers[index].text);
  }

  Future<List<String>> findRhymes() async {
    if (suggestionWord.isNotEmpty) {
      List<String> results =
          await RhymesServices().findFlashRhymes(suggestionWord);
      return results;
    } else {
      return [];
    }
  }

  Widget _moreButton(String suggestionWord) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RhymesSearcher(search4me: suggestionWord)),
          );
        },
        child: Center(
            child: Icon(
          Icons.search,
          size: 24,
          color: Colors.white,
        )),
      ),
    );
  }

  void detectSelectedText(TextEditingController textController) {
    // var selectedText = getSelectionText(textController);
    print("selected " + textController.selection.textInside(textController.text));
    // print("selected:  " + selectedText);
    // if (selectedText.isNotEmpty) {
    //   // setState(() {
    //   //   suggestionWord = selectedText;
    //   // });
    // }
  }
}
