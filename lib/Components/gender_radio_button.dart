import 'package:flutter/material.dart';

class GenderRadioButton extends StatefulWidget {
  const GenderRadioButton({super.key});

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
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.black.withOpacity(.32);
                  }
                  return Colors.black;
                }),
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            Text(
              'Male',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 80,
            ),
            Radio(
                value: 'Female',
                groupValue: groupValue,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.black.withOpacity(.32);
                  }
                  return Colors.black;
                }),
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                  });
                }),
            Text(
              'Female',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
