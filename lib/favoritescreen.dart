import 'package:flutter/material.dart';

class Favoritescreen extends StatelessWidget {
  const Favoritescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Favorites", style: TextStyle(color: Colors.blue, fontSize: 30)), 
    ),  
    );
  }
}