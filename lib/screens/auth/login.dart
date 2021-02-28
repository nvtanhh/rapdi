import 'package:Rapdi/navigator/main_navigator.dart';
import 'package:Rapdi/screens/auth/or_divider.dart';
import 'package:Rapdi/screens/auth/signup.dart';
import 'package:Rapdi/screens/auth/social_icon.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/already_have_an_account_acheck.dart';
import 'package:Rapdi/widgets/rounded_button.dart';
import 'package:Rapdi/widgets/rounded_input_field.dart';
import 'package:Rapdi/widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  final String initEmail;

  const LoginScreen({
    Key key,
    this.initEmail = '',
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _email = widget.initEmail;
    _password = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * 0.8,
                  alignment: Alignment.center,
                  child: Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  "assets/images/login_art.png",
                  // height: size.height * 0.3,
                  width: size.width * 0.8,
                ),
                SizedBox(height: size.height * 0.05),
                RoundedInputField(
                  initValue: _email,
                  hintText: "Địa chỉ email",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: 'Mật khẩu',
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedButton(
                  text: "ĐĂNG NHẬP",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      _login();
                    }
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: "assets/images/ic_facebook.svg",
                      bgColor: Color(0xFF4267B2),
                      press: _loginFacebook,
                    ),
                    SocalIcon(
                      iconSrc: "assets/images/ic_google_plus.svg",
                      press: _loginGoogle,
                      bgColor: Color(0xFFDB4A39),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    Utils.onLoading();

    if (_email.isNotEmpty && _password.isNotEmpty) {
      dynamic result =
          await AuthService().signInWithEmailAndPassword(_email, _password);
      if (result is User) {
        await EasyLoading.dismiss();
        print("user id " + result.uid);
        // navigateToHome(context);
      } else {
        await EasyLoading.dismiss();
        Utils.showToast(result);
      }
    } else {
      Utils.showToast("Email hoặc mật khẩu trống");
    }
  }

  _loginGoogle() async {
    Utils.onLoading();
    dynamic result = await AuthService().signInWithGoogle();
    if (result == null) {
      Utils.showToast("OOPS... Lỗi rồi, Bạn vui long thử lại sau nhé!");
    }
    await EasyLoading.dismiss();
    // navigateToHome(context);
  }

  void _loginFacebook() async {
    Utils.onLoading();
    dynamic result = await AuthService().signInWithFacebook();
    await EasyLoading.dismiss();
    if (result == null) {
      Utils.showToast("OOPS... Lỗi rồi, Bạn vui lòng thử lại sau nhé!");
    }
    await EasyLoading.dismiss();
    // navigateToHome(context);
  }
}

void navigateToHome(BuildContext context) {
  Route route = MaterialPageRoute(builder: (context) => MainNavigator());
  Navigator.pushReplacement(context, route);
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
