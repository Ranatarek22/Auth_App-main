import 'package:flutter/material.dart';

import '../Components/header.dart';
import '../Components/trailer.dart';
import '../Components/login_image.dart';
import '../Components/signin_input_form.dart';
import '../Constants/constants.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customPurple,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(text: 'Welcome Back'),
            SizedBox(height: 30),
            SigninInputForm(),
            SizedBox(height: 10),
            Trailer(
              text: "Don't have an account?",
              textButton: "Sign Up",
              navigationTo: SignUpScreen(),
            ),
            Expanded(child: LoginImage()),
          ],
        ),
      ),
    );
  }
}
