import 'package:http/http.dart' as http;
import 'dart:convert';

class Apifetcher {
    final String apiUrl = "https://zenquotes.io/api/quotes/";
    

   Future<List<Map<String, dynamic>>> fetchQuotes() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl)
      );

      if (response.statusCode == 200){
        List quotes = json.decode(response.body);
        return quotes.map((quote) => {
          'quote': quote['q'],
          'author': quote['a'],
        }).toList();  
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }
}