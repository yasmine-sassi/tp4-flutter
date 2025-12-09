import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/quote.dart';
import '../services/api_service.dart';

class QuoteScreenDio extends StatefulWidget {
  const QuoteScreenDio({Key? key}) : super(key: key);

  @override
  State<QuoteScreenDio> createState() => _QuoteScreenDioState();
}

class _QuoteScreenDioState extends State<QuoteScreenDio> {
  late ApiService _apiService;
  late Quote _quote;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize Dio with configuration
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    // Add interceptor for logging (optional)
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    _apiService = ApiService(dio);
    _quote = Quote(text: '', author: '');
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quotes = await _apiService.getRandomQuote();
      setState(() {
        _quote = quotes.isNotEmpty
            ? quotes[0]
            : Quote(text: 'No quote available', author: '');
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _quote = Quote(text: 'Error: ${e.message}', author: '');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _quote = Quote(text: 'Error: $e', author: '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Quote (Dio/Retrofit)'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.format_quote,
                            size: 40,
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _quote.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '— ${_quote.author}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _fetchQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Get New Quote'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.teal,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Using Dio + Retrofit',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
