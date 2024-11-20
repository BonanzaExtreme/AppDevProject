import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.adventPro(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
