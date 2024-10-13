import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splashscreen(),
  ));
}


/* API fetcher
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteService {
  final String apiUrl = "https://api.example.com/quotes";

  Future<List<String>> fetchQuotes() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List quotes = json.decode(response.body);
      return quotes.map((quote) => quote['text'].toString()).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  
*/

// code for scroll list 
/* import 'package:flutter/material.dart';
import 'quote_service.dart';

class QuoteListScreen extends StatefulWidget {
  @override
  _QuoteListScreenState createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  final QuoteService _quoteService = QuoteService();
  List<String> _quotes = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    List<String> fetchedQuotes = await _quoteService.fetchQuotes();
    setState(() {
      _quotes = fetchedQuotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quotes")),
      body: _quotes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: _quotes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    _quotes[index],
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
    );
  */