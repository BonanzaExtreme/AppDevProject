import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notificationscreen extends StatelessWidget {
  const Notificationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.adventPro(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
