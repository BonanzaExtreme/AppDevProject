import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Favoritescreen extends StatelessWidget {
  const Favoritescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: GoogleFonts.adventPro(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
