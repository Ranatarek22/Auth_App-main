import 'package:assignment1/Model/users.dart';
import 'package:flutter/material.dart';
import 'sql_db.dart';
import '../Model/store.dart';
import '../Model/fav_store.dart';

class StoreProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Store> _stores = [];
  List<FavoriteStore> _favoriteStores = [];
  List<FavoriteStore> get favoritestores => _favoriteStores;
  List<Store> get stores => _stores;

  Future<void> fetchStores() async {
    _stores = await _databaseHelper.getStoresFromDatabase();
    notifyListeners();
  }

  String _userId = ''; 
  UserData? _currentUser; 

  Future<UserData?> fetchUserById(String userId) async {
    _currentUser = await _databaseHelper.getUserById(userId);
    if (_currentUser != null) {
      _userId = _currentUser!.id!;
    }
    return _currentUser;
  }

  
  Future<void> addStore() async {
    Map<String, dynamic> storeData = {
      'name': 'Pizza King',
      'latitude': 31.178312,
      'longitude': 30.185926,
      // 'createdAt': store.createdAt,
      'image': 'assets/images/pizza.png',
    };

    await _databaseHelper.insertStore(storeData);
    await fetchStores();

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

    for (FavoriteStore favoriteStore in favoriteStores) {
      Store? store = await _databaseHelper.getStoreById(favoriteStore.storeId);
      if (store != null) {
        _favoriteStores.add(FavoriteStore(
            id: favoriteStore.id,
            userId: favoriteStore.userId,
            storeId: favoriteStore.storeId,
            store: store 
            ));

      } else {
        print('Store not found for ID: ${favoriteStore.storeId}');
      }
      for (FavoriteStore favoriteStore in _favoriteStores) {
        if (favoriteStore.store != null) {
          print('Favorite Store ID: ${favoriteStore.store!.id}');
          print('Favorite Store Name: ${favoriteStore.store!.name}');
   
        } else {
          print('Store not found for ID: ${favoriteStore.storeId}');
        }
      }
    }
    printFavoriteStores();
  
    notifyListeners();
  }


  Future<void> printFavoriteStoresForUsers() async {
 
    List<UserData> users = await _databaseHelper.getUsers();

  
    for (UserData user in users) {
      print('Favorite stores for user ${user.name}:');

     
      List<FavoriteStore> favoriteStores =
          await _databaseHelper.getFavoriteStores(user.id!);

      
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
          'Store Name: ${favoriteStore.store?.name ?? 'Unknown'}'); 
    }
  }


  Future<void> deleteFavoriteStore(String userId, String storeId) async {
    try {
      await _databaseHelper.deleteFavoriteStoreByUserIdAndStoreId(userId, storeId);
      // Fetch favorite stores again to update the list
      await fetchFavoriteStores(userId);
    } catch (error) {
      print('Error deleting favorite store: $error');
    }
  }

  Future<void> deleteStore(int storeId) async {
    try {
      // Call the deleteStoreById method from DatabaseHelper
      await _databaseHelper.deleteStoreById(storeId);
      // Fetch stores again to update the list
      await fetchStores();
    } catch (error) {
      print('Error deleting store: $error');
    }
  }
  Future<void> deleteAllStores() async {
    await _databaseHelper.deleteAllStores();
    _stores.clear();
    notifyListeners();
  }
}
