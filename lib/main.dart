import 'package:assignment1/Screens/profile_screen.dart';
import 'package:assignment1/Screens/stores_screen.dart';
import 'package:assignment1/Screens/welcome_screen.dart';
import 'package:assignment1/Services/sql_db.dart';
import 'package:assignment1/Services/stores_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper().initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        // Add other providers if needed
      ],
      child: AuthApp(),
    ),
  );
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WelcomeScreen(),
    );
  }
}
