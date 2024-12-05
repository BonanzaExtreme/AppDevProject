import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/assessmentscreen.dart';
import 'package:project/homescreen.dart';
import 'route.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Up.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 220),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  RouteManager.createRoute(Assessmentscreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(136, 210, 253, 1),
              minimumSize: Size(220, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50),
            ),
            child: Text(
              'Get Started!',
              style: GoogleFonts.adventPro(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
        )),
      ),
    );
  }
}
