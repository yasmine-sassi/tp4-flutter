import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/quote.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://zenquotes.io/api')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/random')
  Future<List<Quote>> getRandomQuote();

  @GET('/quotes')
  Future<List<Quote>> getAllQuotes();
}
