import 'package:assignment1/Model/store.dart';

class FavoriteStore {
  final int id;
  final String userId;
  final String storeId;
  Store? store;

  FavoriteStore({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.store,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
    };
  }

  factory FavoriteStore.fromMap(Map<String, dynamic> map, Store store) {
    return FavoriteStore(
      id: map['id'],
      userId: map['userId'],
      storeId: map['storeId'],
      store: store,
    );
  }
}
