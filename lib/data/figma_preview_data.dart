import '../models/news_article.dart';
import '../models/news_category.dart';
import '../models/news_source.dart';

/// Offline visual reference, extracted entirely from the user's supplied 16 PNGs.
/// This data is never presented as a successful NewsAPI response.
class FigmaPreviewData {
  static const sources = <NewsSource>[
    NewsSource(id: '', name: 'ABC News'),
    NewsSource(id: '', name: 'Aftenposten'),
    NewsSource(id: '', name: 'ANSA.it'),
    NewsSource(id: '', name: 'Ary News'),
    NewsSource(id: '', name: 'Axios'),
  ];

  static const articles = <NewsArticle>[
    NewsArticle(
      sourceName: 'ABC News',
      author: 'Jon Haworth',
      title: '40-year-old man falls 200 feet to his death while canyoneering at national park',
      description: 'The man was hiking with three others through Heaps Canyon when he fell.',
      url: '',
      localImage: 'assets/photos/canyon_man.png',
      localVideoPoster: 'assets/photos/zion_video_poster.png',
      displayAge: '15 minutes ago',
      content: 'A 40-year-old man has fallen approximately 200 feet to his death while canyoneering with three others at Zion National Park in Utah, authorities confirmed.\n\nThe incident occurred on Saturday when the group of four were following their permitted itinerary through Heaps Canyon when the man fell around 200 feet, according to a statement from the National Park Service.',
    ),
    NewsArticle(
      sourceName: 'ABC News',
      author: 'DANIEL NIEMANN Associated Press, MIKE CORDER Associated Press',
      title: 'Nobel Prize in physics awarded to two scientists for machine learning discoveries',
      description: 'Nobel Prize in physics awarded to two scientists for machine learning discoveries',
      url: '',
      localImage: 'assets/photos/scientist.png',
      displayAge: '18 minutes ago',
    ),
  ];

  static List<NewsArticle> forCategory(NewsCategory category) => articles;

  static List<NewsArticle> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return articles;
    return articles.where((article) {
      return article.title.toLowerCase().contains(q) ||
          (article.description?.toLowerCase().contains(q) ?? false) ||
          article.sourceName.toLowerCase().contains(q);
    }).toList();
  }
}
