class NewsCategory {
  const NewsCategory(this.key, this.label, this.arabicLabel);
  final String key;
  final String label;
  final String arabicLabel;

  static const all = <NewsCategory>[
    NewsCategory('general', 'General', 'عام'),
    NewsCategory('business', 'Business', 'أعمال'),
    NewsCategory('sports', 'Sports', 'رياضة'),
    NewsCategory('technology', 'Technology', 'تكنولوجيا'),
    NewsCategory('entertainment', 'Entertainment', 'ترفيه'),
    NewsCategory('health', 'Health', 'صحة'),
    NewsCategory('science', 'Science', 'علوم'),
  ];
}
