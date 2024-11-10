import 'package:flutter/material.dart';
import 'package:project/apifetcher.dart';
import 'package:project/navbar.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final Apifetcher _quoteService = Apifetcher();
  List<Map<String, dynamic>> _quotes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    try {
      List<Map<String, dynamic>> fetchedQuotes = await _quoteService.fetchQuotes();
      print('Fetched Quotes: $fetchedQuotes'); // Debug print to check the fetched data
      if (fetchedQuotes.isEmpty) {
        throw Exception('No quotes found');
      }
      setState(() {
        _quotes = fetchedQuotes;
      });
    } catch (error) {
      print('Error fetching quotes: $error'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch quotes: $error')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Uplift me", style: TextStyle(color: Colors.blue, fontSize: 30)),
    ),
    drawer: Navbar(),
    body: _quotes.isEmpty
        ? Center(child: CircularProgressIndicator())
        : PageView.builder(
            itemCount: _quotes.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {

              if (index < _quotes.length) {
                final quote = _quotes[index]['quote'];
                final author = _quotes[index]['author'];

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
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
}