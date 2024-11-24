import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class Favoritescreen extends StatefulWidget {
  @override
  _FavoritescreenState createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  List<String> _favorite_quotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorite_quotes = prefs.getStringList('favorite_quotes') ?? [];
    });
  }

  Future<void> _RemoveFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorite_quotes.removeAt(index);
    });
    await prefs.setStringList('favorite_quotes', _favorite_quotes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Favorites",
            style: GoogleFonts.adventPro(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        body: _favorite_quotes.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Center(
                    child: Text(
                  "No favorite quotes yet.",
                  style: GoogleFonts.adventPro(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                )))
            : Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: _favorite_quotes.length,
                  itemBuilder: (context, index) {
                    String quote = _favorite_quotes[index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: ListTile(
                        title: Text(quote),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _RemoveFavorite(index);
                                },
                                icon: Icon(Icons.delete, color: Colors.black)),
                            IconButton(
                                onPressed: () async {},
                                icon: Icon(Icons.share, color: Colors.black))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
