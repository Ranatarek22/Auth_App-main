import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.onChanged,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          onChanged: widget.onChanged,
          validator: widget.validator,
          obscureText: widget.obscureText && _obscureText,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
