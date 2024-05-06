import 'package:assignment1/Screens/distance_dialog.dart';
import 'package:assignment1/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Constants/constants.dart';
import '../Model/favorite_store.dart';
import '../Model/users.dart';

class FavoriteStoresScreen extends StatefulWidget {
  const FavoriteStoresScreen({super.key, required this.userData});

  final UserData userData;

  @override
  State<FavoriteStoresScreen> createState() => _FavoriteStoresScreenState();
}

class _FavoriteStoresScreenState extends State<FavoriteStoresScreen> {
  List<FavoriteStore> favouriteStores = [
    FavoriteStore(
        id: '1',
        name: 'H&M',
        latitude: 30.013034,
        longitude: 31.258103,
        image: 'assets/images/book_store.png'),
    FavoriteStore(
        id: '2',
        name: 'zara',
        latitude: 29.979732,
        longitude: 31.219625,
        image: 'assets/images/book_store.png'),
  ];

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
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ProfileScreen(user: widget.userData);
                }));
              },
              icon: Icon(
                Icons.person_sharp,
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: favouriteStores.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    _showDistanceDialog(context, favouriteStores[index]);
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        favouriteStores[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      favouriteStores[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Longitude: ${favouriteStores[index].longitude.toString()},',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Latitude: ${favouriteStores[index].latitude.toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

void _showDistanceDialog(BuildContext context, FavoriteStore store) async {
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

Future<Position> _determinePosition() async {
  return await Geolocator.getCurrentPosition();
}


