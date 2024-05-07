
import 'package:assignment1/Model/store.dart';
import 'package:assignment1/Screens/distance_dialog.dart';
import 'package:assignment1/Screens/profile_screen.dart';
import 'package:assignment1/Services/stores_provider.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../Constants/constants.dart';
import '../Model/users.dart';


class FavoriteStoresScreen extends StatefulWidget {
  const FavoriteStoresScreen({Key? key, required this.userData})
      : super(key: key);

  final UserData userData;

  @override
  _FavoriteStoresScreenState createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<StoreProvider>(context, listen: false)
        .fetchFavoriteStores(widget.userData.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: customPurple,
        title: Text(
          "Favorite stores",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
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
          if (storeProvider.favoritestores.isEmpty) {
            return Center(
              child: Text(
                  'No favorite stores'), 
            );
          } else {
            return ListView.builder(
              itemCount: storeProvider.favoritestores.length,
              itemBuilder: (context, index) {
                final store = storeProvider.favoritestores[index].store;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _showDistanceDialog(context, store);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            store?.image ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          store?.name ?? 'Unknown',
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Longitude: ${store?.longitude.toString() ?? ''},',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Latitude: ${store?.latitude.toString() ?? ''}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDistanceDialog(BuildContext context, Store? store) async {
    if (store != null) {
      Position position = await _determinePosition();

      double distance = await Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        store.latitude,
        store.longitude,
      );

      showDialog(
        context: context,
        builder: (context) {
          return DistanceDialog(storeName: store.name, distance: distance);
        },
      );
    }
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }
}

