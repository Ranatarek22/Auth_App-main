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

  Future<void> addStore() async {
    Map<String, dynamic> storeData = {
      'id': '1',
      'name': 'Awlad Ragab',
      'latitude': 900.9,
      'longitude': 800.2,
      // 'createdAt': store.createdAt,
      'image': 'assets/images/book_store.png',
    };
    if (_stores.isNotEmpty && _stores[0].id != storeData['id']) {
      await _databaseHelper.insertStore(storeData);
      await fetchStores();
    } else {
      print('Store ID already exists.');
    }
  }

  Future<void> deleteAllStores() async {
    await _databaseHelper.deleteAllStores();
    _stores.clear();
    notifyListeners();
  }
}
