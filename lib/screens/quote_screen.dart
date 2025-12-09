import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  static const String address = 'https://zenquotes.io/api/random';
  late Quote _quote;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quote = Quote(text: '', author: '');
    _fetchQuote();
  }

  Future<Quote> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Uri url = Uri.parse(address);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> quoteJson = convert.json.decode(response.body);
        Quote quote = Quote.fromJSON(quoteJson[0]);
        setState(() {
          _quote = quote;
          _isLoading = false;
        });
        return quote;
      } else {
        setState(() {
          _quote = Quote(text: 'Error retrieving quote', author: '');
          _isLoading = false;
        });
        return _quote;
      }
    } catch (e) {
      setState(() {
        _quote = Quote(text: 'Error: $e', author: '');
        _isLoading = false;
      });
      return _quote;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Quote'), centerTitle: true),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_quote.text}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '— ${_quote.author}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _fetchQuote,
                      child: const Text('Get New Quote'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// API Response (JSON String)
//         ↓
// [JSON String] → convert.json.decode() → [Map, Map, ...]
//         ↓
//        List<dynamic>
//         ↓
//     quoteJson[0]  (first element)
//         ↓
//    Map<String, dynamic>
//    {"q": "text", "a": "author"}
//         ↓
// Quote.fromJSON(map)
//         ↓
//    Quote Object
//    {text: "text", author: "author"}
