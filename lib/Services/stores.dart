import 'package:assignment1/Model/store.dart';
import 'package:assignment1/Model/users.dart'; // Assuming UserData is defined in this file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Stores {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStore({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? createdAt,
    required String image,
  }) async {
    try {
      // Create a new Store object
      Store store = Store(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        createdAt: createdAt,
        image: image, // Include image field in the map
      );

      // Add store data to Firestore
      await _firestore.collection('stores').add(store.toMap());
    } catch (e) {
      print('Error adding store: $e');
      throw e; // Rethrow the exception to handle it in the UI
    }
  }

  Future<List<Store>> fetchStores() async {
    try {
      // Fetch all stores from Firestore
      QuerySnapshot storeSnapshot = await _firestore.collection('stores').get();

      // Convert each store document to a Store object
      List<Store> stores = storeSnapshot.docs
          .map((store) => Store(
                id: store.id,
                name: store['name'],
                latitude: store['latitude'],
                longitude: store['longitude'],
                createdAt: store['createdAt'],
                image: store['image'],
              ))
          .toList();

      return stores;
    } catch (e) {
      print('Error fetching stores: $e');
      throw e; // Rethrow the exception to handle it in the UI
    }
  }
}
