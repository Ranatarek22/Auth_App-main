import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'custom_text_field.dart';
import 'package:assignment1/Utilities/secure_storage.dart';

class SigninInputForm extends StatefulWidget {
  const SigninInputForm({Key? key});

  @override
  State<SigninInputForm> createState() => _SigninInputFormState();
}

class _SigninInputFormState extends State<SigninInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _tokenStorage = TokenStorage();

  Future<void> _login(BuildContext context) async {
    final baseUrl = 'https://nexus-api-h3ik.onrender.com';
    final endpoint = '/api/auth/signin';
    final url = Uri.parse('$baseUrl$endpoint');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Login successful, handle response
      final token = jsonDecode(response.body)['token'];
      await _tokenStorage.saveToken(token); // Save the token using TokenStorage
      print('Login successful');
      print('Response: ${response.body}');

      // Check if the token is stored
      final storedToken = await _tokenStorage.getToken();
      if (storedToken != null) {
        print('Token stored successfully: $storedToken');
      } else {
        print('Failed to store token');
        // Handle the case where token storage fails
      }
    } else {
      // Login failed, show error message
      print('Login failed');
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: "Enter your email",
            labelText: 'Email',
            icon: Icons.email,
            onChanged: (value) {}, // Add onChanged callback here
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^\d{8}@stud\.fci-cu\.edu\.eg$')
                  .hasMatch(value)) {
                return 'Please enter a FCI email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            hintText: "Enter your password",
            labelText: 'Password',
            icon: Icons.lock,
            onChanged: (value) {}, // Add onChanged callback here
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
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
                  _login(context);
                }
              },
              child: Text(
                "Login",
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}