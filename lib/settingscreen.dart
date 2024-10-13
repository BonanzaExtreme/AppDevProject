import 'package:flutter/material.dart';

class Settingscreen extends StatelessWidget{
  const Settingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Settings", style: TextStyle(color: Colors.blue, fontSize: 30)), 
    ),  
    );
  }
}