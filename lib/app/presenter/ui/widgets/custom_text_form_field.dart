// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../logic/validate_email.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  String? hintName;
  IconData? icon;
  bool isObscureText;
  TextInputType? inputType;
  bool? isEnable;

  CustomTextFormField({
    this.controller,
    this.hintName,
    this.icon,
    this.isObscureText = false,
    this.inputType = TextInputType.text,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        enabled: isEnable,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Favor preencher o campo $hintName.';
          }
          if (hintName == "Email" && !validateEmail(value)) {
            return 'Por favor, insira um email válido.';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              borderSide: BorderSide(color: Color.fromARGB(141, 13, 103, 177))),
          prefixIcon: Icon(icon),
          hintText: hintName,
          labelText: hintName,
          fillColor: const Color.fromARGB(144, 20, 126, 212),
          filled: true,
        ),
      ),
    );
  }
}
