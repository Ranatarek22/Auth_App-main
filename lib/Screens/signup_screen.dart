import 'package:assignment1/Components/custom_button.dart';
import 'package:assignment1/Components/signup_input_form.dart';
import 'package:assignment1/Components/trailer.dart';
import 'package:assignment1/Screens/login_screen.dart';
import 'package:assignment1/Constants/constants.dart';
import 'package:flutter/material.dart';
import '../Components/header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customPurple,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 34,
              ),
              Header(text: 'Sign Up'),
              SignupInputForm(),
              SizedBox(height: 10),
              // CustomButton(
              //   text: 'Create Account',
              //   onPressed: () {},
              // ),
              Trailer(
                text: 'Already have an account?',
                textButton: 'Sign In',
                navigationTo: LoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
