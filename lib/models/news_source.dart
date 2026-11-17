class NewsSource {
  const NewsSource({required this.id, required this.name});

  final String id;
  final String name;

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String || json['name'] is! String) {
      throw const FormatException('unexpectedError');
    }
    return NewsSource(id: json['id'] as String, name: json['name'] as String);
  }
}
