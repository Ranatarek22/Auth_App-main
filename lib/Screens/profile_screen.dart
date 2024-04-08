import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/users.dart';
import '../Services/sql_db.dart';
import 'edit_profile_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseHelper _databaseHelper; // Database helper instance
  String? _imagePath;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(); // Initialize database helper
    _imagePath = widget.user.imagePath; // Set initial image path from user data
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagePath = _image!.path;
        _saveImagePathToDatabase(); // Save image path to database
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImagePathToDatabase() async {
    // Update the user's image path in the database
    widget.user.setImagePath(_imagePath!);
    await _databaseHelper.updateUser(widget.user.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    _buildProfileAvatar(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildEditIconButton(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildProfileInfo(),
              SizedBox(height: 20),
              _buildEditProfileButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return SizedBox(
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
    );
  }

  Widget _buildEditIconButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Text(
          widget.user.name!,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.user.email!,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return EditProfileScreen(
              user: widget.user,
            );
          }),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      child: SizedBox(
        height: 50,
        width: 150,
        child: Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
