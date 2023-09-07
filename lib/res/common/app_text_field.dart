import 'package:flutter/material.dart';

import 'media_query.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final Widget? icon;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    this.controller,
    this.icon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) / 30),
      child: TextField(
        autofocus: true,
        controller: controller!,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            hintText: hintText!,
            icon: icon!,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(width(context) / 25)),
      ),
    );
  }
}
