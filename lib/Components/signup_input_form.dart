import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_text_field.dart';
import 'level_list.dart';
import 'gender_radio_button.dart';
import 'package:assignment1/Model/users.dart'; // Importing the User model
import 'package:assignment1/Services/sql_db.dart'; // Importing the DatabaseHelper class

class SignupInputForm extends StatefulWidget {
  const SignupInputForm({Key? key});

  @override
  State<SignupInputForm> createState() => _SignupInputFormState();
}

class _SignupInputFormState extends State<SignupInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? name,
      email,
      studentId,
      password,
      confirmPassword,
      level,
      gender; // Include level attribute

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<void> _saveUserToDatabase(BuildContext context) async {
    final User user = User(
      name: _nameController.text,
      email: _emailController.text,
      studentId: _studentIDController.text,
      password: _passwordController.text,
      level: level,
      gender: gender,
    );

    // Save user to local database
    int result = await _databaseHelper.insertUser(user.toMap());
    if (result == -1) {
      // Email already exists, show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'This email is already in use. Please use a different email.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the method
    }
  }

  Future<void> _signup(BuildContext context) async {
    final baseUrl = 'https://nexus-api-h3ik.onrender.com';
    final endpoint = '/api/auth/signup';

    final url = Uri.parse('$baseUrl$endpoint');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final User user = User(
      name: _nameController.text,
      email: _emailController.text,
      studentId: _studentIDController.text,
      password: _passwordController.text,
      level: level,
      gender: gender,
    );

    // Save user to local database
    int result = await _databaseHelper.insertUser(user.toMap());
    if (result == -1) {
      // Email already exists, show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'This email is already in use. Please use a different email.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the method
    }

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(user.toMap()),
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
            controller: _studentIDController,
            hintText: "Enter your ID",
            labelText: 'Student ID',
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
          LevelList(
            onChanged: (value) {
              setState(() {
                level = value; // Update level attribute
              });
            },
          ),
          GenderRadioButton(
            onChanged: (value) {
              setState(() {
                gender = value; // Update gender attribute
              });
            },
          ), // Include GenderRadioButton widget
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveUserToDatabase(context);
                  // _signup(context);
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
    _studentIDController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
