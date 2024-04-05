import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 380,
      width: 350,
      child: Image(
        image: AssetImage(
          'assets/images/girl2.png',
        ),
      ),
    );
  }
}
