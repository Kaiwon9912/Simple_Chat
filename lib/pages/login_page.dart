import 'dart:ffi';


import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/styled_button.dart';
import '../component/styled_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();



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
  void signIn() async
  {

    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      Navigator.pop(context);
    }
    on FirebaseAuthException catch (e)
    {
      Navigator.pop(context);
     LoginError();

    }


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
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: StyledTextfield(
                controller: emailController,
                hintText: 'Email',
                ObscureText: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: StyledTextfield(
                controller: passwordController,
                hintText: 'Password',
                ObscureText: true,
              ),
            ),
            Align(
              alignment: Alignment.topRight,

              child: Container(
                margin: EdgeInsets.only(right: 25, top: 10),
                child: Text(
                    'Forgot password ?'
                ),
              ),
            ),
            const SizedBox(height: 25,),
            StyledButton(
              text: 'Sign in',
              onTap: signIn,
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
                    AuthService().signInWithGoogle();
                  },
                  child: Image.asset('lib/images/gg.png', height: 40,)),
            ),
            const SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Doesn't have account ? "),
                GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Register ", style: TextStyle(color: Colors.blueAccent),)),
              ]
            )
          ],
        ),
      ),
    );
  }
}
