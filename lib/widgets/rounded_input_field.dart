import 'package:Rapdi/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  final String initValue;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.mail,
    this.onChanged,
    this.autofocus = false,
    this.initValue = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (val) {
          if (val.length == 0)
            return "Please enter email";
          else if (!isEmail(val))
            return "Please enter valid email";
          else
            return null;
        },
        initialValue: this.initValue,
        autofocus: this.autofocus,
        onChanged: onChanged,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppTheme.primaryColor,
        decoration: InputDecoration(
          fillColor: AppTheme.primaryLightColor,
          filled: true,
          prefixIcon: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }

  bool isEmail(String email) {
    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(email);
  }
}
