import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  late File _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

//API
Future<void> uploadImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://example.com/upload'),
  );

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ),
  );

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Image uploaded successfully');
  } else {
    print('Failed to upload image');
  }
}


