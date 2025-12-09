import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/quote.dart';
import '../services/api_service.dart';

class QuotesListScreenDio extends StatefulWidget {
  const QuotesListScreenDio({Key? key}) : super(key: key);

  @override
  State<QuotesListScreenDio> createState() => _QuotesListScreenDioState();
}

class _QuotesListScreenDioState extends State<QuotesListScreenDio> {
  late ApiService _apiService;
  List<Quote> _quotes = [];
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

    // Add interceptor for logging
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    _apiService = ApiService(dio);
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quotes = await _apiService.getAllQuotes();
      setState(() {
        _quotes = quotes;
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _quotes = [];
        _isLoading = false;
      });
      _showErrorSnackBar('Dio Error: ${e.message}');
    } catch (e) {
      setState(() {
        _quotes = [];
        _isLoading = false;
      });
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Quotes (Dio/Retrofit)'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchQuotes,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.teal.shade50,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.teal, size: 16),
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _quotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No quotes available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchQuotes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                      final quote = _quotes[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.teal.shade100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: Colors.teal.shade400,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      quote.text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '— ${quote.author}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
