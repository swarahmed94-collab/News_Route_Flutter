import '../models/news_article.dart';
import '../models/news_category.dart';
import '../models/news_source.dart';
import '../services/news_api_service.dart';
import 'figma_preview_data.dart';

class NewsRepository {
  NewsRepository({required String apiKey})
      : _api = apiKey.isEmpty ? null : NewsApiService(apiKey: apiKey);

  final NewsApiService? _api;

  /// With no supplied API key, offline screens use only Figma-export contents.
  bool get previewMode => _api == null;

  Future<List<NewsSource>> sources(NewsCategory category) async {
    if (_api == null) return FigmaPreviewData.sources;
    return _api.sources(category);
  }

  Future<List<NewsArticle>> headlines(
    NewsCategory category, {
    String? sourceId,
  }) async {
    if (_api == null) return FigmaPreviewData.forCategory(category);
    return _api.headlines(category: category, sourceId: sourceId);
  }

  Future<List<NewsArticle>> search(String query) async {
    if (_api == null) return FigmaPreviewData.search(query);
    return _api.search(query);
  }

  void dispose() => _api?.dispose();
}
