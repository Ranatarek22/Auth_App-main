import 'package:assignment1/Model/users.dart';
import 'package:flutter/material.dart';
import 'sql_db.dart';
import '../Model/store.dart';
import '../Model/fav_store.dart';

class StoreProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Store> _stores = [];
  List<FavoriteStore> _favoriteStores = [];

  List<Store> get stores => _stores;

  // Method to fetch stores from the database
  Future<void> fetchStores() async {
    _stores = await _databaseHelper.getStoresFromDatabase();
    notifyListeners();
  }

 String _userId = ''; // Variable to store the user ID
  UserData? _currentUser; // Variable to store the current user

  // Method to fetch the user by ID
  Future<void> fetchUserById(String userId) async {
    _currentUser = await _databaseHelper.getUserById(userId);
    if (_currentUser != null) {
      _userId = _currentUser!.id!;
    }
  }



  // Method to add a new store
  Future<void> addStore() async {
    Map<String, dynamic> storeData = {
      'name': 'H&M',
      'latitude': 900.9,
      'longitude': 800.2,
      // 'createdAt': store.createdAt,
      'image': 'assets/images/book_store.png',
    };

    await _databaseHelper.insertStore(storeData);
    await fetchStores();

    // Fetch stores again to update the list
  }

  Future<void> addToFavorites(Store store, String userId) async {
    try {
      await _databaseHelper.insertFavoriteStore(userId, store.id);
      notifyListeners();
    } catch (error) {
      print('Error adding store to favorites: $error');
    }
  }

  Future<void> fetchFavoriteStores(String userId) async {
    _favoriteStores = [];
    List<FavoriteStore> favoriteStores =
        await _databaseHelper.getFavoriteStores(userId);

    // Convert Store objects to FavoriteStore objects
    for (FavoriteStore favoriteStore in favoriteStores) {
      Store? store = await _databaseHelper.getStoreById(favoriteStore.storeId);
      if (store != null) {
        _favoriteStores.add(FavoriteStore(
          id: favoriteStore.id,
          userId: favoriteStore.userId,
          storeId: favoriteStore.storeId,
          store: store, // Assign the fetched store to the FavoriteStore object
        ));
      } else {
        // Handle the case where the store is not found
        // You can log an error or skip adding the favorite store
        print('Store not found for ID: ${favoriteStore.storeId}');
      }
    }
    printFavoriteStores();
    // Update the list of favorite stores in StoreProvider
    _stores =
        _favoriteStores.map((favoriteStore) => favoriteStore.store!).toList();
    // Notify listeners
    notifyListeners();
  }
Future<void> printFavoriteStoresForUsers() async {
    // Fetch all users from the database
    List<UserData> users = await _databaseHelper.getUsers();

    // Iterate over each user
    for (UserData user in users) {
      print('Favorite stores for user ${user.name}:');

      // Fetch favorite stores for the current user
      List<FavoriteStore> favoriteStores =
          await _databaseHelper.getFavoriteStores(user.id!);

      // Print favorite stores for the current user
      for (FavoriteStore favoriteStore in favoriteStores) {
        print('Favorite Store ID: ${favoriteStore.id}');
        print('User ID: ${favoriteStore.userId}');
        print('Store ID: ${favoriteStore.storeId}');
        print('Store Name: ${favoriteStore.store?.name ?? 'Unknown'}');
        print('-------------------------');
      }
    }
  }
  void printFavoriteStores() {
    for (FavoriteStore favoriteStore in _favoriteStores) {
      print('Favorite Store ID: ${favoriteStore.id}');
      print('User ID: ${favoriteStore.userId}');
      print('Store ID: ${favoriteStore.storeId}');
      print(
          'Store Name: ${favoriteStore.store?.name ?? 'Unknown'}'); // Access store name with null check
      // Print other store details as needed
    }
  }

  Future<void> deleteAllStores() async {
    await _databaseHelper.deleteAllStores();
    _stores.clear();
    notifyListeners();
  }
}
