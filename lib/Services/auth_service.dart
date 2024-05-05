import 'package:assignment1/Model/users.dart'; // Assuming UserData is defined in this file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String studentId,
    String? gender,
    String? level,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new User object
      UserData user = UserData(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        studentId: studentId,
        password: password, // Note: Storing password in Firestore might not be advisable in a real-world app
        level: level,
        gender: gender,
      );

      // Add user data to Firestore
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Error signing up: $e');
      throw e; // Rethrow the exception to handle it in the UI
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sign-in successful, no further action needed in this method
    } catch (e) {
      print('Error signing in: $e');
      throw e; // Rethrow the exception to handle it in the UI
    }
  }

  Future<void> uploadImageToStorage(image, userEmail) async {
    if (image != null) {
      try {
        final file = await image.readAsBytes();

        final storageInstance = FirebaseStorage.instance
            .ref('$userEmail/${image.path.split('/').last}');

        final TaskSnapshot uploadTask = await storageInstance.putData(file);

        // Get download URL of the uploaded image
        // final String downloadURL = await uploadTask.ref.getDownloadURL();

        // Update user data in Firestore with the image path
        // await _firestore.collection('users').doc(userEmail).update({
        //   'imagePath': downloadURL,
        // });
      } catch (error) {
        print('Error uploading image: $error');
        throw error;
      }
    }
  }
}
