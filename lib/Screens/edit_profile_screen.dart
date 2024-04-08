import 'dart:io';
import 'package:assignment1/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/custom_text_field.dart';
import '../Components/gender_radio_button.dart';
import '../Components/level_list.dart';
import '../Constants/constants.dart';
import '../Model/users.dart';
import '../Services/sql_db.dart';

class EditProfileScreen extends StatefulWidget {
  final User user; // Add a user parameter to receive user data
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController(); // Add old password controller
  final TextEditingController _newPasswordController = TextEditingController(); // Add new password controller
  final TextEditingController _confirmPasswordController = TextEditingController(); // Add confirm password controller
  late String gender; // Initialize gender
  late String level; // Initialize level
  late String password;
  late String confirmPassword;
  final _formKey = GlobalKey<FormState>(); // Add form key

  @override
  void initState() {
    super.initState();
    // Initialize text field controllers with user data
    _nameController.text = widget.user.name!;
    _studentIDController.text = widget.user.studentId!;
    gender = widget.user.gender ?? ''; // Initialize gender with user data
    level = widget.user.level ?? ''; // Initialize level with user data
    password = ''; // Initialize password
    confirmPassword = ''; // Initialize confirm password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile picture and edit button
                _buildProfileAvatar(),
                SizedBox(height: 20),
                // Custom text fields wrapped in Form
                CustomTextField(
                  controller: _nameController,
                  hintText: "Enter your name",
                  labelText: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _studentIDController,
                  hintText: "Enter your ID",
                  labelText: 'Student ID',
                  icon: Icons.card_membership,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student ID';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _oldPasswordController,
                  hintText: "Enter old password (if changing)",
                  labelText: 'Old Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    // Allow empty string if field is not being changed
                    if (_newPasswordController.text.isEmpty && value == null || value!.isEmpty) {
                      return null;
                    }
                    if (value != widget.user.password) {
                      return 'Old password does not match';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: "Enter new password (if changing), at least 8 characters",
                  labelText: 'New Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    // Allow empty string if field is not being changed
                    if (value!.isEmpty) {
                      return null;
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: "Re-enter new password",
                  labelText: 'Confirm New Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    // Allow empty string if field is not being changed
                    if (_newPasswordController.text.isEmpty && value == null || value!.isEmpty) {
                      return null;
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                LevelList(
                  onChanged: (value) {
                    setState(() {
                      level = value!;
                    });
                  },
                  initialValue: widget.user.level, // Pass initial value to the list
                ),
                GenderRadioButton(
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  initialValue: widget.user.gender, // Pass initial value to the radio button
                ),
                SizedBox(height: 20),
                SizedBox(
                  width:200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle update logic here
                      _updateProfile(context);
                    },
                    child: Text(
                      "Update Profile",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: customPurple,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to update profile
  void _updateProfile(BuildContext context) async {
    // Validate form fields
    if (_formKey.currentState!.validate()) {
      // Create a new user object with updated data
      User updatedUser = User(
        id: widget.user.id,
        name: _nameController.text,
        email: widget.user.email, // Do not update email
        studentId: _studentIDController.text,
        gender: gender,
        level: level,
        password: _newPasswordController.text.isNotEmpty ? _newPasswordController.text : widget.user.password,
      );

      // Call the update method from DatabaseHelper
      int result = await DatabaseHelper().updateUser(updatedUser.toMap());

      if (result != 0) {
        // Update successful
        // You can show a success message or navigate back
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return ProfileScreen(user: updatedUser);
          }),
        );
      } else {
        // Update failed
        // You can show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Change Profile Photo'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Image.asset(
                  'assets/images/istockphoto-1300845620-612x612-removebg-preview.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Change Profile Photo'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple, // Background color of the button
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white, // Color of the icon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
