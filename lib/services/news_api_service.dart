import 'dart:convert';
import 'dart:io';

import '../models/news_article.dart';
import '../models/news_category.dart';
import '../models/news_source.dart';

// Every route/parameter/response key below is defined in https://newsapi.org/docs.
// No undocumented fallback endpoint or invented response field is used.
class NewsApiException implements Exception {
  const NewsApiException(this.code, this.message, this.httpStatus);
  final String code;
  final String message;
  final int httpStatus;

  @override
  String toString() => message;
}

class NewsApiService {
  NewsApiService({required String apiKey, HttpClient? httpClient})
      : _apiKey = apiKey,
        _client = httpClient ?? HttpClient();

  final String _apiKey;
  final HttpClient _client;

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> queryParameters,
  ) async {
    final uri = Uri.https('newsapi.org', path, queryParameters);
    final request = await _client.getUrl(uri);
    request.headers.set('X-Api-Key', _apiKey);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    final response = await request.close();
    final body = await utf8.decoder.bind(response).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('unexpectedError');
    }
    if (response.statusCode != HttpStatus.ok || decoded['status'] != 'ok') {
      throw NewsApiException(
        decoded['code'] is String ? decoded['code'] as String : 'unexpectedError',
        decoded['message'] is String
            ? decoded['message'] as String
            : 'unexpectedError',
        response.statusCode,
      );
    }
    return decoded;
  }

  Future<List<NewsSource>> sources(NewsCategory category) async {
    final json = await _get('/v2/top-headlines/sources', {
      'category': category.key,
    });
    final items = json['sources'];
    if (items is! List) throw const FormatException('unexpectedError');
    return items
        .whereType<Map<String, dynamic>>()
        .map(NewsSource.fromJson)
        .toList(growable: false);
  }

  Future<List<NewsArticle>> headlines({
    required NewsCategory category,
    String? sourceId,
  }) async {
    // Per NewsAPI: sources MUST NOT be combined with country or category.
    final parameters = sourceId == null
        ? <String, String>{'country': 'us', 'category': category.key}
        : <String, String>{'sources': sourceId};
    final json = await _get('/v2/top-headlines', parameters);
    return _parseArticles(json);
  }

  Future<List<NewsArticle>> search(String query) async {
    final json = await _get('/v2/everything', {'q': query});
    return _parseArticles(json);
  }

  List<NewsArticle> _parseArticles(Map<String, dynamic> json) {
    final items = json['articles'];
    if (items is! List) throw const FormatException('unexpectedError');
    return items
        .whereType<Map<String, dynamic>>()
        .map(NewsArticle.fromJson)
        .toList(growable: false);
  }

  void dispose() => _client.close(force: true);
}
