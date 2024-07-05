import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool loginState = true;
  void tooglePages()
  {
    setState(() {
      loginState=!loginState;
    });
  }
  @override
  Widget build(BuildContext context) {
    return loginState?LoginPage(onTap: tooglePages,):RegisterPage(onTap: tooglePages,);
  }
}
