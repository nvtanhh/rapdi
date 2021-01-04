import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Tài khoản',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SettingsList(
          physics: BouncingScrollPhysics(),
          backgroundColor: Colors.white,
          sections: [
            SettingsSection(
              title: 'Tài khoản',
              tiles: [
                SettingsTile(
                  title: 'Email',
                  subtitle: _auth.getCurrentUser().email ?? "Null",
                  leading: Icon(Icons.email_outlined),
                ),
                SettingsTile(
                    title: 'Đăng xuất',
                    leading: Icon(Icons.logout),
                    onPressed: (BuildContext context) {
                      _showDeleteDialog();
                    }),
              ],
            ),
            CustomSection(
              child: SizedBox(
                height: 20,
              ),
            ),
            SettingsSection(
              title: 'Khác',
              tiles: [
                SettingsTile(
                  title: 'Góp ý cho lập trình viên',
                  leading: Icon(Icons.chat),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Mời tôi một cốc coffe',
                  leading: Icon(FontAwesomeIcons.coffee),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Liên hệ',
                  subtitle: 'Tanh Nguyen',
                  leading: Icon(FontAwesomeIcons.facebook),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Chia sẻ',
                  leading: Icon(Icons.share_rounded),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
          ],
        ),
      ),
      // child: ListView(
      //   children: [_accountSection(), _miscSession()],
      // )),
    );
  }

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
          content: Text("Bạn có chắc muốn đăng xuất không?"),
          actions: <Widget>[
            new FlatButton(
                child: const Text("HUỶ"),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop()),
            new FlatButton(
              child: const Text(
                "ĐĂNG XUẤT",
                style: TextStyle(color: AppTheme.holderColor),
              ),
              onPressed: _signOut,
            ),
          ]),
    );
  }

  void _signOut() async {
    Utils.onLoading();
    await Future.delayed(Duration(milliseconds: 500), AuthService().signOut);
    await EasyLoading.dismiss();
  }

  _miscSession() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khác',
          style: TextStyle(
              color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        // _settingItem(
        //     icon: Icons.mail, title: 'Email', subTitle: 'kingtxx98@gmail.com'),
      ],
    );
  }

  _accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tài khoản',
          style: TextStyle(
              color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        _settingItem(
            icon: Icons.mail, title: 'Email', subTitle: 'kingtxx98@gmail.com'),
      ],
    );
  }

  Widget _settingItem({IconData icon, String title, String subTitle}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(right: 30),
              child: Icon(
                icon,
                color: Colors.black54,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(subTitle, style: TextStyle(fontSize: 14))
              ],
            ),
          )
        ],
      ),
    );
  }
}
