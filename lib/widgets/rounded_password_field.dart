import 'package:Rapdi/app_theme.dart';
import 'package:Rapdi/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  final String hintText;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.hintText = 'Password',
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (val) {
          if (val.length == 0)
            return "Please enter password";
          else if (val.length <= 5)
            return "Your password should be more then 6 char long";
          else
            return null;
        },
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onChanged,
        cursorColor: AppTheme.primaryColor,
        decoration: InputDecoration(
          fillColor: AppTheme.primaryLightColor,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.lock,
            color: AppTheme.primaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: _obscureText
                ? Icon(
                    Icons.visibility,
                    color: AppTheme.primaryColor.withOpacity(.7),
                  )
                : Icon(
                    Icons.visibility_off,
                    color: AppTheme.primaryColor.withOpacity(.7),
                  ),
          ),
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
}
