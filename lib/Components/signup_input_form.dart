import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_text_field.dart';

class SignupInputForm extends StatefulWidget {
  const SignupInputForm({Key? key});

  @override
  State<SignupInputForm> createState() => _SignupInputFormState();
}

class _SignupInputFormState extends State<SignupInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController birthDate = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? name, email, studentId, password, confirmPassword;

  Future<void> _signup(BuildContext context) async {
    final baseUrl = 'https://nexus-api-h3ik.onrender.com';
    final endpoint = '/api/auth/signup';

    final url = Uri.parse('$baseUrl$endpoint');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'name': _nameController.text,
      'email': _emailController.text,
      'studentId': birthDate.text,
      'password': _passwordController.text,
      // Add more fields as required
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Signup successful, handle response
      print('Signup successful');
      print('Response: ${response.body}');
      // Optionally, navigate to the next screen or show a success message
    } else {
      // Signup failed, show error message
      print('Signup failed');
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _nameController,
            hintText: "Enter your name",
            labelText: 'Name',
            icon: Icons.person,
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: _emailController,
            hintText: "Enter your FCI email",
            labelText: 'Email',
            icon: Icons.email,
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: birthDate,
            hintText: "Enter your ID",
            labelText: 'Birth Day',
            icon: Icons.card_membership,
            onChanged: (value) {
              setState(() {
                studentId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your student ID';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: _passwordController,
            hintText: "Enter password (at least 8 characters)",
            labelText: 'Password',
            icon: Icons.lock,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: "Re-enter password",
            labelText: 'Confirm Password',
            icon: Icons.lock,
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
            },
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please re-enter your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signup(context);
                }
              },
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10),
                backgroundColor: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    birthDate.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
