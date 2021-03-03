import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/donate_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:mailto/mailto.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SettingsList(
                physics: BouncingScrollPhysics(),
                backgroundColor: Colors.transparent,
                sections: [
                  SettingsSection(
                    title: 'Tài khoản',
                    tiles: [
                      _buildAccountTitle(),
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
                        onPressed: (BuildContext context) async {
                          await launchMailto();
                        },
                      ),
                      SettingsTile(
                        title: 'Mời tôi một cốc coffe',
                        leading: Icon(FontAwesomeIcons.coffee),
                        onPressed: (BuildContext context) {
                          showDonateDialog();
                        },
                      ),
                      SettingsTile(
                        title: 'Đánh giá ứng dụng',
                        leading: Icon(Icons.star),
                        onPressed: (BuildContext context) {
                          rateApp();
                        },
                      ),
                    ],
                  ),
                  CustomSection(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                      child: Opacity(
                        opacity: .7,
                        child: Row(
                          children: [
                            Text('Powered by  '),
                            GestureDetector(
                              onTap: () {
                                _launchSocial('fb://profile/100013221849622',
                                    'https://www.facebook.com/nvtanhh');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Color(0xff3b5998),
                                    size: 18,
                                  ),
                                  Text(
                                    ' Tanh Nguyen',
                                    style: TextStyle(color: Color(0xff3b5998)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // child: ListView(
      //   children: [_accountSection(), _miscSession()],
      // )),
    );
  }

  getAppBarUI() {
    return Container(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(child: Text('Tài khoản', style: AppTheme.largeTitle)),
          ],
        ));
  }

  void _launchSocial(String url, String fallbackUrl) async {
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['nvtanh.dev@gmail.com'],
      subject: 'Feedback from: RAPDI',
      body: 'Hi, Tanh!\r\n',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
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

  void showDonateDialog() {
    var mess =
        "Xin chào các bạn, xin tự giới thiệu mình tên là Tánh Nguyễn - một lập trình viên, cũng là một người rất yêu thích nhạc rap. Mình viết ứng dụng này với hy vọng đóng góp một phần nào đó cho các bạn chơi nhạc rap ở Việt Nam.\n\nMọi sự ủng hộ của các bạn mình sẽ dùng để duy trì máy chủ và nâng cấp ứng dụng! ❤️";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Mời tôi một cốc coffe",
          descriptions: mess,
        );
      },
    );
  }

  void rateApp() {
    LaunchReview.launch(androidAppId: "");
  }

  _buildAccountTitle() {
    var providerId = _auth.getCurrentUser().providerData[0].providerId;
    switch (providerId) {
      case 'facebook.com':
        return SettingsTile(
          title: _auth.getCurrentUser().providerData[0].displayName,
          leading: Icon(FontAwesomeIcons.facebook, color: Color(0xff3b5998)),
        );
        break;
      case 'google.com':
        return SettingsTile(
          title: _auth.getCurrentUser().providerData[0].displayName,
          leading: Icon(FontAwesomeIcons.google, color: Color(0xffae4335)),
        );
        break;
      default:
        return SettingsTile(
          title: (_auth.getCurrentUser().email == null ||
                  _auth.getCurrentUser().email.isEmpty)
              ? null
              : _auth.getCurrentUser().email,
          leading: Icon(Icons.email_outlined),
        );
    }
  }
}
