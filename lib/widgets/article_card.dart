import 'package:flutter/material.dart';

import '../models/news_article.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article, required this.onTap});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final primary = dark ? Colors.white : const Color(0xFF171717);
    final muted = dark ? Colors.white60 : const Color(0xFF989898);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primary, width: 0.8),
        ),
        padding: const EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: SizedBox(
                width: double.infinity,
                height: 222,
                child: NewsImage(article: article),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              article.title,
              style: TextStyle(
                color: primary,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'By : ${article.byline}',
                    style: TextStyle(fontSize: 12, color: muted, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (article.age.isNotEmpty) ...<Widget>[
                  const SizedBox(width: 5),
                  Text(
                    article.age,
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsImage extends StatelessWidget {
  const NewsImage({super.key, required this.article});
  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    if (article.localImage != null) {
      return Image.asset(article.localImage!, fit: BoxFit.cover);
    }
    final url = article.urlToImage;
    if (url == null || url.isEmpty) {
      return const ColoredBox(color: Color(0xFFE2E2E2));
    }
    final parsed = Uri.tryParse(url);
    if (parsed == null ||
        (parsed.scheme != 'https' && parsed.scheme != 'http')) {
      return const ColoredBox(color: Color(0xFFE2E2E2));
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, error, stackTrace) =>
          const ColoredBox(color: Color(0xFFE2E2E2)),
    );
  }
}
