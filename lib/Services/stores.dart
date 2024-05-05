import 'package:flutter/material.dart';
import 'sql_db.dart';
import '../Model/store.dart'; // Import your store model

class StoreProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Store> _stores = [];
  List<Store> get stores => _stores;

  // Method to fetch stores from the database
  Future<void> fetchStores() async {
    _stores = await _databaseHelper.getStoresFromDatabase();
    notifyListeners();
  }

  // Method to add a new store
  Future<void> addStore(Store store) async {
    // Prepare store data as a map
    Map<String, dynamic> storeData = {
      'id': store.id,
      'name': store.name,
      'latitude': store.latitude,
      'longitude': store.longitude,
      'createdAt': store.createdAt,
      'image': store.image,
    };

    // Insert the store into the database
    await _databaseHelper.insertStore(storeData);

    // Fetch stores again to update the list
    await fetchStores();
  }
   Future<void> deleteAllStores() async {
    await _databaseHelper.deleteAllStores();
    _stores.clear();
    notifyListeners();
  }
}
