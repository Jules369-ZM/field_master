import 'package:field_master/utils/utils.dart';
import 'package:flutter/material.dart';

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
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: 'Enter your password',
        border: const OutlineInputBorder(),
        errorText: widget.error,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(
            _hidePassword ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
