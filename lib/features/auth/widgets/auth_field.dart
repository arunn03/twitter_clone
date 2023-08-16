import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.hintText,
    this.hideText = false,
    this.inputType = TextInputType.text,
    required this.onSaved,
    required this.validator,
  });

  final String hintText;
  final bool hideText;
  final TextInputType inputType;
  final void Function(String?) onSaved;
  final String? Function(String?) validator;

  @override
  State<StatefulWidget> createState() {
    return _AuthFieldState();
  }
}

class _AuthFieldState extends State<AuthField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.redColor,
            width: 3,
          ),
        ),
        errorStyle: const TextStyle(
          color: Pallete.redColor,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Pallete.redColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Pallete.greyColor),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
        contentPadding: const EdgeInsets.all(22),
      ),
      obscureText: widget.hideText,
      keyboardType: widget.inputType,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
