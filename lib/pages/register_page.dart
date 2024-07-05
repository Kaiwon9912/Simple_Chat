import 'dart:ffi';


import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/styled_button.dart';
import '../component/styled_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final password_confirmController = TextEditingController();


  void LoginError()
  {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            'Incorrect Email or Password'
        ),
      );
    });
  }
  void Register()
  {
      if(passwordController.text != password_confirmController.text)
        {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text(
                  'Password do not match'
              ),
            );
          });
        }
      AuthService().Register(usernameController.text,emailController.text, passwordController.text);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Icon(
              Icons.lock,
              size: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Login to continue !',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  StyledTextfield(
                    controller: usernameController,
                    hintText: 'Username',
                    ObscureText: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StyledTextfield(
                    controller: emailController,
                    hintText: 'Email',
                    ObscureText: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    ObscureText: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledTextfield(
                    controller: password_confirmController,
                    hintText: 'Confirm Password',
                    ObscureText: true,
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20,),
            StyledButton(
              text: 'Register',
              onTap: Register,
            ),
            Row(
              children: [
                Expanded(child: Divider(thickness: 2, color: Colors.grey,)),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'or Continue with', style: TextStyle(fontSize: 16),),
                ),
                Expanded(child: Divider(thickness: 2, color: Colors.grey,)),

              ],

            ),
            Center(

              child:GestureDetector(
                  onTap: (){
                    AuthService().Register(usernameController.text,emailController.text ,passwordController.text);
                  },
                  child: Image.asset('lib/images/gg.png', height: 40,)),
            ),
            const SizedBox(height: 25,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account ? "),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login ", style: TextStyle(color: Colors.blueAccent),)),
                ]
            )
          ],
        ),
      ),
    );
  }
}
