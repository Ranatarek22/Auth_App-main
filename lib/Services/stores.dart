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
  Future<void> addStore() async {
    await fetchStores();
    // Prepare store data as a map
    Map<String, dynamic> storeData = {
      'id': '1',
      'name': 'H&M',
      'latitude': 900.9,
      'longitude': 800.2,
      // 'createdAt': store.createdAt,
      'image': 'assets/images/book_store.png',
    };
    
      await _databaseHelper.insertStore(storeData);
      
      // Fetch stores again to update the list
      
   
  }

  Future<void> deleteAllStores() async {
    await _databaseHelper.deleteAllStores();
    _stores.clear();
    notifyListeners();
  }
}
