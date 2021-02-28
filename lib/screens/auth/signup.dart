import 'package:Rapdi/screens/auth/login.dart';
import 'package:Rapdi/services/auth.dart';
import 'package:Rapdi/utils/utils.dart';
import 'package:Rapdi/widgets/already_have_an_account_acheck.dart';
import 'package:Rapdi/widgets/rounded_button.dart';
import 'package:Rapdi/widgets/rounded_input_field.dart';
import 'package:Rapdi/widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _rePassword;

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
                    "ĐĂNG KÝ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  "assets/images/login_art.png",
                  // height: size.height * 0.3,
                  width: size.width * 0.8,
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  // autofocus: true,
                  hintText: "Địa chỉ email",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Mật khẩu",
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Nhập lại mật khẩu",
                  onChanged: (value) {
                    _rePassword = value;
                  },
                ),
                RoundedButton(
                  text: "ĐĂNG KÝ",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      if (_password != _rePassword) {
                        Utils.showToast("Passwords not match.", time: 2);
                      } else {
                        Utils.onLoading();
                        dynamic result = await AuthService()
                            .registerWithEmailAndPassword(_email, _password);
                        if (result is User) {
                          Navigator.of(context).pop(); // pop out the popup

                          // show toast and redirect to login screen
                          EasyLoading.showSuccess("Đăng ký thành công!");
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen(
                              initEmail: _email,
                            );
                          }));
                        } else {
                          Utils.showToast(result, time: 2);
                        }
                      }
                    }
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.25,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
