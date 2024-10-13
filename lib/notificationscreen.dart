import 'package:flutter/material.dart';

class Notificationscreen extends StatelessWidget {
  const Notificationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Notifications", style: TextStyle(color: Colors.blue, fontSize: 30)), 
    ),  
    );
  }
}