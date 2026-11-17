import 'package:flutter_test/flutter_test.dart';
import 'package:news_route/models/news_article.dart';
import 'package:news_route/models/news_category.dart';
import 'package:news_route/data/news_repository.dart';

void main() {
  test('NewsAPI article maps documented JSON response keys', () {
    final article = NewsArticle.fromJson(<String, dynamic>{
      'source': <String, dynamic>{'id': 'abc-news', 'name': 'ABC News'},
      'author': 'Example Author',
      'title': 'Test title',
      'description': 'Test description',
      'url': 'https://example.org/story',
      'urlToImage': 'https://example.org/image.png',
      'publishedAt': '2026-11-17T08:00:00Z',
      'content': 'Test content',
    });
    expect(article.sourceId, 'abc-news');
    expect(article.sourceName, 'ABC News');
    expect(article.title, 'Test title');
    expect(article.content, 'Test content');
    expect(article.publishedAt?.isUtc, true);
  });

  test('No key gives only exported Figma preview data', () async {
    final repository = NewsRepository(apiKey: '');
    expect(repository.previewMode, isTrue);
    final sources = await repository.sources(NewsCategory.all.first);
    final articles = await repository.headlines(NewsCategory.all.first);
    expect(sources.first.name, 'ABC News');
    expect(articles.first.title,
      '40-year-old man falls 200 feet to his death while canyoneering at national park');
    repository.dispose();
  });

  test('Preview search filters the original screenshot headlines', () async {
    final repository = NewsRepository(apiKey: '');
    final result = await repository.search('Nobel');
    expect(result.length, 1);
    expect(result.single.title, contains('Nobel Prize'));
    repository.dispose();
  });
}
