import 'package:flutter/material.dart';
import 'package:project/navbar.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uplift me", style: TextStyle(color: Colors.blue, fontSize: 30)), 
      ),
      drawer: Navbar(),
      body: const Center(
        child: Text('Home screen'),
      ),
    );
  }
}
