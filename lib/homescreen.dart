import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/apifetcher.dart';
import 'package:project/favoritescreen.dart';
import 'package:project/navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class Homescreen extends StatefulWidget {
  final List<String> selectedCategories;
  Homescreen({required this.selectedCategories});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Apifetcher _quoteService = Apifetcher();
  List<Map<String, dynamic>> _quotes = [];
  List<String> _keywords = [];
  List<String> _favorite_quotes = [];
  List<String> _categoryimagePath = [
    'assets/images/anxiety.png',
    'assets/images/change.png',
    'assets/images/choice.png',
    'assets/images/confidence.png',
    'assets/images/courage.png',
    'assets/images/death.png',
    'assets/images/dreams.png',
    'assets/images/excellence.png',
    'assets/images/failure.png',
    'assets/images/fairness.png',
    'assets/images/fear.png',
    'assets/images/forgiveness.png',
    'assets/images/freedom.png',
    'assets/images/future.png',
    'assets/images/happiness.png',
    'assets/images/inspiration.png',
    'assets/images/kindness.png',
    'assets/images/leadership.png',
    'assets/images/life.png',
    'assets/images/living.png',
    'assets/images/love.png',
    'assets/images/pain.png',
    'assets/images/past.png',
    'assets/images/success.png',
    'assets/images/time.png',
    'assets/images/today.png',
    'assets/images/truth.png',
    'assets/images/work.png',
  ];
  String _selectedCategory = ''; // Default to empty so random
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    print('Selected categories in Homescreen: ${widget.selectedCategories}');
    _selectedCategories = widget.selectedCategories;
    _fetchQuotes(); // fetch  quotes
    _fetchKeyWords(); // fetch categories
    _loadFavorites(); //load favorited quotes
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

  Future<void> _fetchQuotes() async {
    if (_selectedCategories.isEmpty) return;

    try {
      List<Map<String, dynamic>> fetchedQuotes = [];
      List<String> categoriesToFetch = _selectedCategories;
      categoriesToFetch.shuffle();
      print('Fetching quotes for the following categories: $categoriesToFetch');

      for (String category in _selectedCategories) {
        print('Fetching quotes for category: $category');

        List<Map<String, dynamic>> quotesFromCategory =
            await _quoteService.fetchQuotes(keyword: category);

        print(
            'Received ${quotesFromCategory.length} quotes for category: $category');

        fetchedQuotes.addAll(quotesFromCategory);
      }

      fetchedQuotes.shuffle();

      // Debug: Print the total number of quotes fetched
      print('Total quotes fetched: ${fetchedQuotes.length}');

      setState(() {
        _quotes = fetchedQuotes;
      });
    } catch (error) {
      print('Error fetching quotes: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch quotes: $error')),
      );
    }
  }

  void _updateSelectedCategories(List<String> selectedCategories) {
    setState(() {
      _selectedCategories = selectedCategories;
    });
    _fetchQuotes();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorite_quotes = prefs.getStringList('favorite_quotes') ?? [];
    });
  }

  Future<void> _navigateToFavorites() async {
    final updatedFavorites = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Favoritescreen()),
    );

    if (updatedFavorites != null) {
      setState(() {
        _favorite_quotes = List<String>.from(updatedFavorites);
      });
    }
  }

  bool _isFavorited(String quote, String author) {
    String quoteText = "$quote - $author";
    return _favorite_quotes.contains(quoteText);
  }

  Future<void> _toggleFavorite(String quote, String author) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quoteText = "$quote - $author";

    setState(() {
      if (_isFavorited(quote, author)) {
        _favorite_quotes.remove(quoteText);
      } else {
        _favorite_quotes.add(quoteText);
      }
    });

    await prefs.setStringList('favorite_quotes', _favorite_quotes);
    _loadFavorites();
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
                  bool isFavorited = _isFavorited(quote, author);

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
                                icon: Icon(
                                  Icons.favorite,
                                  color: isFavorited ? Colors.red : Colors.grey,
                                ),
                                iconSize: 60,
                                onPressed: () {
                                  _toggleFavorite(quote, author);
                                },
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.share),
                                iconSize: 60,
                                onPressed: () async {
                                  final share =
                                      await Share.share('$quote - $author');
                                  print(share);
                                },
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

  void bottomsheet(BuildContext context) {
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
                    border: Border(bottom: BorderSide(color: Colors.black)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "CATEGORIES",
                        style: GoogleFonts.adventPro(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ListView.builder(
                      itemCount: _keywords.length,
                      itemBuilder: (context, index) {
                        String category = _keywords[index];
                        return CheckboxListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.adventPro(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset(
                                _categoryimagePath[index],
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                          value: _selectedCategories.contains(category),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                              _selectedCategories = _selectedCategories
                                  .where((cat) =>
                                      cat == category ||
                                      _selectedCategories.contains(cat))
                                  .toList();
                            });

                            _updateSelectedCategories(_selectedCategories);
                          },
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
