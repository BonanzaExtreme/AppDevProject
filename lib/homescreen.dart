import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/apifetcher.dart';
import 'package:project/navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Apifetcher _quoteService = Apifetcher();
  List<Map<String, dynamic>> _quotes = [];
  List<String> _keywords = [];
  List<String> _categoryimagePath = [
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/'
        'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/',
    'assets/images/'
        'assets/images/'
  ];
  String _selectedCategory = ''; // Default to empty so random

  @override
  void initState() {
    super.initState();
    _fetchQuotes(); // fetch random quotes
    _fetchKeyWords(); // fetch categories
  }

//ifefetch yung avail na categories
  Future<void> _fetchKeyWords() async {
    try {
      List<String> fetchedKeywords = await _quoteService.fetchKeywords();
      setState(() {
        _keywords = fetchedKeywords;
      });
    } catch (error) {
      print('Error fetching quotes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch categories: $error')),
      );
    }
  }

  Future<void> _fetchQuotes({String? category}) async {
    try {
      List<Map<String, dynamic>> fetchedQuotes =
          await _quoteService.fetchQuotes(keyword: category);
      setState(() {
        _quotes = fetchedQuotes;
        _selectedCategory = category ?? '';
      });
    } catch (error) {
      print('Error fetching quotes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch quotes: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "UPLIFT ME",
          style: GoogleFonts.adventPro(
              color: Colors.blue, fontSize: 40, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: IconButton(
                onPressed: () {
                  bottomsheet(context);
                },
                icon: const Icon(Icons.filter_list)),
          )
        ],
      ),
      drawer: Navbar(),
      body: _quotes.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : PageView.builder(
              itemCount: _quotes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (index < _quotes.length) {
                  final quote = _quotes[index]['quote'];
                  final author = _quotes[index]['author'];

                  return Center(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  quote,
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '- $author',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite),
                                onPressed: () {
                                  _addTofavorites(quote, author);
                                },
                              ),
                              SizedBox(
                                  width:
                                      20), // Space between heart and favorite icon

                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () async {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No quotes available.'));
                }
              },
            ),
    );
  }

  Future<void> _addTofavorites(String quote, String author) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorite_quotes = prefs.getStringList('favorite_quotes') ?? [];

    String quoteText = "$quote - $author";

    if (!favorite_quotes.contains(quoteText)) {
      favorite_quotes.add(quoteText);
    }

    await prefs.setStringList('favorite_quotes', favorite_quotes);
  }

  void bottomsheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Title(
                  color: Colors.blue,
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: Container(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            "CATEGORIES",
                            style: GoogleFonts.adventPro(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      )))),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: _keywords.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = _keywords[index];
                            });
                            _fetchQuotes(category: _keywords[index]);
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 1,
                                  color: const Color.fromARGB(255, 41, 41, 41),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _keywords[index],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.adventPro(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    _categoryimagePath[index],
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              )));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
