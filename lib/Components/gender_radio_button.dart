import 'package:flutter/material.dart';

class GenderRadioButton extends StatefulWidget {
  final Function(String) onChanged; // Add a callback function

  const GenderRadioButton({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<GenderRadioButton> createState() => _GenderRadioButtonState();
}

class _GenderRadioButtonState extends State<GenderRadioButton> {
  String groupValue = 'Male'; //gender

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value.toString();
                  widget.onChanged(
                      groupValue); // Pass selected value to parent widget
                });
              },
            ),
            Text(
              'Male',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 80,
            ),
            Radio(
              value: 'Female',
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value.toString();
                  widget.onChanged(
                      groupValue); // Pass selected value to parent widget
                });
              },
            ),
            Text(
              'Female',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }
}
