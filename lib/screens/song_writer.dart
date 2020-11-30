import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/custom_icon_icons.dart';
import 'package:Rapdi/models/Song.dart';
import 'package:Rapdi/screens/song_demos.dart';
import 'package:Rapdi/services/firestore_service.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/recorder_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongWriter extends StatefulWidget {
  // final LocalFileSystem localFileSystem;
  final Song song;

  final Function() notifyParent;

  SongWriter({song, this.notifyParent})
      : this.song = song ?? Song.empty(suffix: Utils.currentDateTime());

  @override
  _SongWriterState createState() => _SongWriterState();
}

class _SongWriterState extends State<SongWriter> {
  FiretoreService songProvider;
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> _lyricFocuses = [];
  List<TextEditingController> _lyricControllers = [];

  @override
  void initState() {
    generateLyrics();
    super.initState();
  }

  @override
  void dispose() {
    saveAll();
    // FocusScope.of(context).unfocus();
    if (widget.notifyParent != null) widget.notifyParent();
    super.dispose();
  }

  Future<void> saveAll() async {
    widget.song.lyric = getLyrics();
    widget.song.title = _titleController.text.trim();
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
    if (widget.song.lyric == '')
      widget.song.lyric = ' ';
    else if (widget.song.lyric[0] != ' ')
      widget.song.lyric = ' ' + widget.song.lyric; // if null init default value

    List<String> lines = widget.song.lyric.split('\n');
    for (int i = 0; i < lines.length; i++) {
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
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
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
          ],
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return TextField(
      enableSuggestions: false,
      controller: _titleController..text = widget.song.title ?? '',
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
        hintText: "Tên bài hát",
        hintStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(.2)),
      ),
      maxLines: 1,
      onChanged: (value) {
        // song.title = value;
      },
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(_lyricFocuses[0]);
      },
    );
  }

  Widget _contentTextField(int index) {
    String prefix = (index % 2 == 0) ? 'A  ' : 'B  ';
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextField(
        enableSuggestions: false,
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
        keyboardType: TextInputType.multiline,
        decoration: new InputDecoration(
            isCollapsed: true,
            prefixText: prefix,
            prefixStyle: TextStyle(fontSize: 13, color: AppTheme.accentColor),
            border: InputBorder.none),

        onChanged: (value) => _processOnchanged(index, value),
        // FocusScope.of(context).requestFocus(focus);
      ),
    );
  }

  bool isPressDelete(String value) {
    return value.isEmpty || value[0] != ' ';
  }

  _processOnchanged(int index, String value) {
    if (value.isEmpty && index >= 1) {
      // press delete key
      setState(() {
        _lyricControllers.removeAt(index);
        _lyricFocuses[index - 1].requestFocus();
        _lyricFocuses.removeAt(index);
      });
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
        });
      }
    }
  }
}
