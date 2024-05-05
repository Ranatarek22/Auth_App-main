import 'package:assignment1/Constants/constants.dart';
import 'package:flutter/material.dart';

import '../Model/store_model.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresScreen> {
  List<StoreModel> stores = [
    StoreModel(
        name: 'Book Store',
        image: 'assets/images/book_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'my Store',
        image: 'assets/images/default_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'Book Store',
        image: 'assets/images/book_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'my Store',
        image: 'assets/images/default_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'Book Store',
        image: 'assets/images/book_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'my Store',
        image: 'assets/images/default_store.png',
        location: '1st albert street,chicago'),
    StoreModel(
        name: 'Book Store',
        image: 'assets/images/book_store.png',
        location: '1st albert street,chicago'),
  ];

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
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0), // Increase vertical padding to increase height
            child: ListTile(
              contentPadding: EdgeInsets.zero, // Remove default horizontal padding
              dense: true, // Make ListTile more compact
              //visualDensity: VisualDensity(horizontal: 0, vertical: -4), // Adjust visual density to reduce height
              leading: SizedBox(
                width: 100, // Increase width of the SizedBox to make image larger
                height: 100, // Increase height of the SizedBox to make image larger
                child: Image.asset(
                  stores[index].image,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                stores[index].name,
                style: TextStyle(fontSize: 20), // Increase font size of the title text
              ),
              subtitle: Text(
                stores[index].location,
                style: TextStyle(fontSize: 16), // Increase font size of the subtitle text
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // Add store to favorites
                },
              ),
            ),
          );
        },
      ),
    );
  }


}
