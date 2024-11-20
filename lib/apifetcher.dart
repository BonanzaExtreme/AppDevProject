import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Apifetcher {
  final String baseUrl =
      "https://zenquotes.io/api/quotes/[366d72907b7f6f2b6e47d9d10a77b108]";
  Future<List<String>> fetchKeywords() async {
    List<String> categories = [
      'anxiety',
      'change',
      'choice',
      'confidence',
      'courage',
      'death',
      'dreams',
      'excellence',
      'failure',
      'fairness',
      'fear',
      'forgiveness',
      'freedom',
      'future',
      'happiness',
      'inspiration',
      'kindness',
      'leadership',
      'life',
      'living',
      'love',
      'pain',
      'past',
      'success',
      'time',
      'today',
      'truth',
      'work',
    ];

    return categories;
  }

  Future<List<Map<String, dynamic>>> fetchQuotes({String? keyword}) async {
    String url =
        "https://zenquotes.io/api/quotes/[366d72907b7f6f2b6e47d9d10a77b108]";

    if (keyword != null && keyword.isNotEmpty) {
      url = "$url&keyword=$keyword";
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List quotes = json.decode(response.body);

        return quotes
            .map((quote) => {
                  'quote': quote['q'],
                  'author': quote['a'],
                })
            .toList();
      } else {
        throw Exception('Failed to load quotes');
      }
    } catch (e) {
      throw Exception('Error fetching quotes: $e');
    }
  }
}
