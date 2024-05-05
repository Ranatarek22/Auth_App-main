// import 'dart:html';
import 'dart:io';
import 'package:assignment1/Screens/profile_screen.dart';
import 'package:assignment1/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/custom_text_field.dart';
import '../Components/gender_radio_button.dart';
import '../Components/level_list.dart';
import '../Constants/constants.dart';
import '../Model/users.dart';
import '../Services/sql_db.dart';
import 'package:path_provider/path_provider.dart';
//
class EditProfileScreen extends StatefulWidget {
  final UserData user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late DatabaseHelper _databaseHelper;
  String? _imagePath;
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  final TextEditingController _oldPasswordController =
      TextEditingController(); 
  final TextEditingController _newPasswordController =
      TextEditingController(); 
  final TextEditingController _confirmPasswordController =
      TextEditingController(); 
  late String gender;
  late String level;
  late String password;
  late String confirmPassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name!;
    _studentIDController.text = widget.user.studentId!;
    gender = widget.user.gender ?? ''; 
    level = widget.user.level ?? ''; 
    password = '';
    confirmPassword = '';
    _databaseHelper = DatabaseHelper();
    _imagePath = widget.user.imagePath;
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    String? imagePath =
    await _databaseHelper.getUserImagePath(widget.user.email!);
    setState(() {
      _imagePath = imagePath;
    });
  }
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagePath = _image!.path;
      } else {
        print('No image selected.');
      }
    });
    if (_image != null && _imagePath != null) {
      await saveImageToDevice(_image!, _imagePath!.toString().split('/').last);
      await _saveImagePathToDatabase();
      await AuthService().uploadImageToStorage(_image, widget.user.email);
    }
  }


  Future<void> _saveImagePathToDatabase() async {
    widget.user.setImagePath(_imagePath!);
    try {
      await _databaseHelper.updateUser(widget.user.toMap());
      // final Directory directory = await getApplicationDocumentsDirectory();
      // print(directory.path);
    } catch (error) {
      print(error);
    }
  }

  Future<void> saveImageToDevice(File imageFile, String imageName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/uploads/$imageName';
      final File newImage = await imageFile.copy(imagePath);
      _imagePath = newImage.path;
      print('Image saved to: ${newImage.path}');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); 
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
              
                _buildProfileAvatar(),
                SizedBox(height: 20),
              
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
                    if (_newPasswordController.text.isEmpty && value == null ||
                        value!.isEmpty) {
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
                  hintText:
                      "Enter new password (if changing), at least 8 characters",
                  labelText: 'New Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
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
                    if (_newPasswordController.text.isEmpty && value == null ||
                        value!.isEmpty) {
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
                  initialValue:
                      widget.user.level, 
                ),
                GenderRadioButton(
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  initialValue: widget
                      .user.gender,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
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

 
  void _updateProfile(BuildContext context) async {
    
    if (_formKey.currentState!.validate()) {
      UserData updatedUser = UserData(
        id: widget.user.id,
        name: _nameController.text,
        email: widget.user.email, 
        studentId: _studentIDController.text,
        gender: gender,
        level: level,
        password: _newPasswordController.text.isNotEmpty
            ? _newPasswordController.text
            : widget.user.password,
        imagePath: _imagePath,
      );

     
      int result = await DatabaseHelper().updateUser(updatedUser.toMap());

      if (result != 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: updatedUser),
          ),
        );
      } else {
       
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _imagePath != null
                    ? Image.file(File(_imagePath!), fit: BoxFit.cover)
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
                  color: Colors.purple, 
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
