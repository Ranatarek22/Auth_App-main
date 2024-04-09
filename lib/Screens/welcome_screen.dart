import 'package:assignment1/Screens/login_screen.dart';
import 'package:assignment1/Screens/signup_screen.dart';
import 'package:assignment1/Constants/constants.dart';
import 'package:flutter/material.dart';

import '../Components/welcome_button.dart';
//
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: customPurple,
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          Text(
            'Welcome To ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            'Our App!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          WelcomeButton(
            buttonText: 'Sign In',
            navigationTo: LoginScreen(),
          ),
          SizedBox(
            height: 20,
          ),
          WelcomeButton(
            buttonText: 'Sign Up',
            navigationTo: SignUpScreen(),
          ),
          Spacer(
            flex: 1,
          ),
          Image(
            image: AssetImage('assets/images/girl1.png'),
          ),
        ],
      ),
    );
  }
}
