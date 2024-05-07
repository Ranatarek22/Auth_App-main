import 'package:assignment1/Constants/constants.dart';
import 'package:assignment1/Model/users.dart';
import 'package:assignment1/Screens/profile_screen.dart';
import 'package:assignment1/Services/auth_service.dart';
import 'package:assignment1/Screens/favorite_stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/stores_provider.dart';
import '../Model/store.dart';

class StoresScreen extends StatefulWidget {
  final String userId;
  final UserData userData;

  const StoresScreen({Key? key, required this.userId, required this.userData})
      : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // Provider.of<StoreProvider>(context, listen: false).deleteStore(19);
      //  Provider.of<StoreProvider>(context, listen: false).addStore();
      Provider.of<StoreProvider>(context, listen: false).fetchStores();
      Provider.of<StoreProvider>(context, listen: false)
          .fetchFavoriteStores(widget.userId);
      Provider.of<StoreProvider>(context, listen: false).addStore();
      //  Provider.of<StoreProvider>(context, listen: false).deleteAllStores();
      //Future<UserData?> userData = Provider.of<StoreProvider>(context, listen: false).fetchUserById(widget.userId);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: customPurple,
        title: Text(
          "Stores",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FavoriteStoresScreen(
                      userData: widget.userData,
                    );
                  },
                ),
              );
            },
            icon: Icon(
              Icons.favorite,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfileScreen(user: widget.userData);
              }));
            },
            icon: Icon(
              Icons.person_sharp,
            ),
          ),
        ],
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          List<Store> stores = storeProvider.stores;
          List<String> favoriteStoreIds =
              storeProvider.favoritestores.map((e) => e.storeId).toList();

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              bool isFavorite = favoriteStoreIds.contains(stores[index].id);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        stores[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      stores[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Longitude: ${stores[index].longitude.toString()}, Latitude: ${stores[index].latitude.toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () async {
                        setState(() {
                          if (isFavorite) {
                            Provider.of<StoreProvider>(context, listen: false)
                                .deleteFavoriteStore(
                                    widget.userId, stores[index].id);
                          } else {
                            Provider.of<StoreProvider>(context, listen: false)
                                .addToFavorites(stores[index], widget.userId)
                                .then((_) {
                              Provider.of<StoreProvider>(context, listen: false)
                                  .fetchFavoriteStores(widget.userId);
                            });
                          }
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
// //20200588@stud.fci-cu.edu.eg
// //12345678





