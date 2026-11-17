class NewsArticle {
  const NewsArticle({
    required this.sourceName,
    this.sourceId,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.localImage,
    this.localVideoPoster,
    this.displayAge,
  });

  final String? sourceId;
  final String sourceName;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  // These are exclusively the user's original Figma-export image crops.
  final String? localImage;
  final String? localVideoPoster;
  final String? displayAge;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    if (source is! Map<String, dynamic> ||
        json['title'] is! String ||
        json['url'] is! String) {
      throw const FormatException('unexpectedError');
    }
    return NewsArticle(
      sourceId: source['id'] is String ? source['id'] as String : null,
      sourceName: source['name'] is String ? source['name'] as String : '',
      author: json['author'] is String ? json['author'] as String : null,
      title: json['title'] as String,
      description: json['description'] is String
          ? json['description'] as String
          : null,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] is String
          ? json['urlToImage'] as String
          : null,
      publishedAt: json['publishedAt'] is String
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
      content: json['content'] is String ? json['content'] as String : null,
    );
  }

  String get byline => author == null || author!.trim().isEmpty
      ? sourceName
      : author!;

  String get age {
    if (displayAge != null) return displayAge!;
    final date = publishedAt;
    if (date == null) return '';
    final span = DateTime.now().difference(date);
    if (span.isNegative) return '';
    if (span.inMinutes < 60) return '${span.inMinutes} minutes ago';
    if (span.inHours < 24) return '${span.inHours} hours ago';
    return '${span.inDays} days ago';
  }
}
