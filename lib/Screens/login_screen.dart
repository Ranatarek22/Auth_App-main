import 'package:assignment1/Components/custom_button.dart';
import 'package:assignment1/Components/login_image.dart';
import 'package:assignment1/Components/signin_input_form.dart';
import 'package:assignment1/Constants/constants.dart';
import 'package:flutter/material.dart';

import '../Components/header.dart';
import '../Components/trailer.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customPurple,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 10,
              ),
              Header(
                text: 'Welcome Back',
              ),
              SizedBox(
                height: 30,
              ),
              SigninInputForm(),
              SizedBox(
                height: 10,
              ),
              // CustomButton(text: 'Login',onPressed: (){},),
              Trailer(
                text: "Don't have an account?",
                textButton: "Sign Up",
                navigationTo: SignUpScreen(),
              ),
              LoginImage(),
            ],
          ),
        ),
      ),
    );
  }
}
