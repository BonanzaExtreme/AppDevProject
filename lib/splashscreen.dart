import 'package:flutter/material.dart';
import 'package:project/homescreen.dart';
import 'route.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(RouteManager.createRoute(const Homescreen()));
          },
          child: const Text('Go!'),
        ),
      ),
    );
  }
}
