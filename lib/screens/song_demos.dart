import 'dart:io';

import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/widgets/demo_item_card.dart';
import 'package:Rapdi/widgets/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SongDemo extends StatefulWidget {
  final String songId;

  SongDemo({@required this.songId});

  @override
  _SongDemoState createState() => _SongDemoState();
}

class _SongDemoState extends State<SongDemo> {
  List<String> m4aFilesPath = [];
  bool _isReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllDemo();
  }

  void loadAllDemo() async {
    String songId = widget.songId;
    String subDir = songId == null ? '' : 'song$songId';
    print('songId:   ' + widget.songId.toString());

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$subDir/');
    if (!await _appDocDirFolder.exists()) {
      print('create folder ' + _appDocDirFolder.toString());
      await _appDocDirFolder.create(recursive: true);
    }
    List<FileSystemEntity> dirFiles = _appDocDirFolder.listSync();
    // Glob audio files that are not the temp file.
    List<FileSystemEntity> m4aFilesTemp = dirFiles
        .where((file) => (file.path.endsWith('.m4a') &&
            file.path.split('/').last != 'TempRecording.m4a'))
        .toList();

    for (FileSystemEntity file in m4aFilesTemp) {
      if (file.path.endsWith('.m4a')) {
        m4aFilesPath.add(file.path);
      }
    }

    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        // padding: EdgeInsets.only(top: 10),
        child: CustomScrollView(
          slivers: <Widget>[
            sliverAppBar(context),
            SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: _isReady
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => Container(
                          child: DemoItem(
                            filePath: m4aFilesPath[index],
                            songId: widget.songId,
                            onDeleteFile: deleteFile,
                          ),
                        ),
                        childCount: m4aFilesPath.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      toolbarHeight: 56,
      elevation: 50,
      pinned: true,
      floating: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      flexibleSpace: CustomSilverAppbar(
        title: 'Demos',
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_outlined,
          color: AppTheme.primaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  deleteFile(String filePath) {
    File file = new File(filePath);
    file.deleteSync();
    setState(() {
      m4aFilesPath.remove(filePath);
    });
  }
}
