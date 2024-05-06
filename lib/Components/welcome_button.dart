import 'package:flutter/material.dart';
//
class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, required this.buttonText, required this.navigationTo});

  final String buttonText;
  final Widget navigationTo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 284,
      height: 59,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return navigationTo;
              },
            ),
          );
        },
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
