import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/widgets/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

class MyDictionary extends StatefulWidget {
  final String word;

  MyDictionary({@required this.word});

  @override
  _MyDictionaryState createState() => _MyDictionaryState();
}

class _MyDictionaryState extends State<MyDictionary> {
  List<String> m4aFilesPath = [];
  bool _isReady = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    _loadDict();
  }

  Future<void> _loadDict() async {
    final webScraper = WebScraper('https://vtudien.com');
    if (await webScraper
        .loadWebPage('/viet-viet/dictionary/nghia-cua-tu-${widget.word}')) {
      final elements = webScraper.getElement('#idnghia > span', []);
      elements.forEach((element) {
        final title = element['title'];
        result += ' ✏️ $title\n\n';
      });
      setState(() => _isReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            sliverAppBar(context),
            SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: _isReady
                  ? SliverToBoxAdapter(
                      child: Text(
                        result,
                        textAlign: TextAlign.justify,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 110,
      toolbarHeight: 56,
      elevation: 50,
      pinned: true,
      floating: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      flexibleSpace: CustomSilverAppbar(
        title: 'Nghĩa của từ ${widget.word}',
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
}
