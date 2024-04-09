import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  late DatabaseHelper _databaseHelper;
  String? _imagePath;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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
              SizedBox(height: 250),
              _buildLogOutButton(context),
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

  Widget _buildLogOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // await _databaseHelper.updateUserLoginStatus(widget.user.email!, false);
        // Navigate to the login screen
        Navigator.of(context).pushReplacementNamed(
            '/login_screen'); // Replace with your login screen route
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[100]), // Choose your button color
      child: SizedBox(
        height: 50,
        width: 150,
        child: Center(
          child: Text(
            'Log Out',
            style: TextStyle(color: Colors.black, fontSize: 20),
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
          color: Colors.purple,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
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
