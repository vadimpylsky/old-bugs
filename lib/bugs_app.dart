import 'package:flutter/material.dart';

import 'home_page.dart';

class BugsApp extends StatelessWidget {
  const BugsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Old Bugs App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
