import 'package:assignment1/Constants/constants.dart';
import 'package:assignment1/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/stores.dart';
import '../Model/store.dart';

class StoresScreen extends StatefulWidget {
  final String userId; // Add userId parameter here

  const StoresScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<StoreProvider>(context, listen: false).fetchStores();
      // Provider.of<StoreProvider>(context, listen: false).addStore();
      //  Provider.of<StoreProvider>(context, listen: false).deleteAllStores();
      _isInit = false;
    }
  }

  @override
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
              Navigator.pushNamed(context, 'AddStoreScreen');
            },
            icon: Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'ProfileScreen');
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
          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                  subtitle: Text(
                    'Longitude: ${stores[index].longitude.toString()}, Latitude: ${stores[index].latitude.toString()}',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {
                      // Get the current user ID
                      storeProvider.addToFavorites(
                          stores[index], widget.userId);
                          //  Provider.of<StoreProvider>(context, listen: false)
                          // .printFavoriteStoresForUsers();
                    },
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
