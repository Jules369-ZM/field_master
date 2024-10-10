// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
    this._controller, {
    super.key,
    this.label = 'Password',
    this.onChanged,
    this.error,
  });
  final TextEditingController _controller;
  final String label;
  final dynamic Function(String)? onChanged;
  final String? error;
  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: widget._controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _hidePassword,
      onChanged: widget.onChanged,
      validator: (text) => validateTextField(value: text, field: widget.label),
      decoration: kTextFieldDecoration.copyWith(
        hintText: '******',
        errorText: widget.error,
        isDense: true,
        isCollapsed: true,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(navKey.currentContext!).colorScheme.tertiary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
