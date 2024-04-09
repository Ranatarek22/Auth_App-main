import 'package:flutter/material.dart';


class Trailer extends StatelessWidget {
  const Trailer(
      {super.key,
      required this.text,
      required this.textButton,
      required this.navigationTo});

  final String text;
  final String textButton;
  final Widget navigationTo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return navigationTo;
              }),
            );
          },
          child: Text(
            textButton,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
