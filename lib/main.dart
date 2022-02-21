import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:old_bugs/bugs_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyAPxp5q1DCh-tbZyONzkZfK2kScq0D3qJw",
      authDomain: "bugs-dev-befd3.firebaseapp.com",
      projectId: "bugs-dev-befd3",
      storageBucket: "bugs-dev-befd3.appspot.com",
      messagingSenderId: "666642624017",
      appId: "1:666642624017:web:99d272cf61b6e56c364bb0",
      measurementId: "G-N6025XMLGL");

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const BugsApp());
}
