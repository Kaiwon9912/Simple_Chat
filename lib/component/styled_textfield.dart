import 'package:flutter/material.dart';

class StyledTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool ObscureText;
  const StyledTextfield({super.key, required this.controller,required this.hintText,required this.ObscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(

      controller: controller,
      obscureText: ObscureText,
      decoration: InputDecoration(
          hintText: hintText,

          enabledBorder: OutlineInputBorder(

              borderSide: BorderSide(color: Colors.grey)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: Colors.black)
          )

      ),

    );

  }
}
