import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/news_article.dart';
import '../services/external_article_opener.dart';
import '../widgets/article_card.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF171717);
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        fontFamily: 'Roboto',
        useMaterial3: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 52,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.menu, color: Colors.black),
                    ),
                    if (article.sourceName == 'ABC News')
                      Image.asset(
                        'assets/branding/abc_news.png',
                        height: 37,
                        fit: BoxFit.contain,
                      )
                    else
                      Text(
                        article.sourceName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 32),
                  children: <Widget>[
                    Text(
                      article.title,
                      style: TextStyle(
                        color: color,
                        fontSize: 22,
                        height: 1.18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (article.description?.isNotEmpty ?? false) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        article.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF686868),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: 'By ',
                            style: TextStyle(color: Color(0xFF999999)),
                          ),
                          TextSpan(
                            text: article.byline,
                            style: const TextStyle(
                              color: Color(0xFF1A5DAA),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (article.publishedAt != null)
                      Text(
                        _formatDate(article.publishedAt!),
                        style: const TextStyle(
                          color: Color(0xFF9299A6),
                          fontSize: 12,
                        ),
                      )
                    else if (article.localImage != null)
                      const Text(
                        'October 8, 2024, 9:38 AM',
                        style: TextStyle(
                          color: Color(0xFF9299A6),
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 25),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => _shareArticle(article.url),
                          child: const Icon(Icons.facebook, size: 17, color: Colors.black),
                        ),
                        const SizedBox(width: 22),
                        InkWell(
                          onTap: () => _shareArticle(article.url),
                          child: const Text('X', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 22),
                        InkWell(
                          onTap: () => _shareArticle(article.url),
                          child: const Icon(Icons.mail_outline, size: 17),
                        ),
                        const SizedBox(width: 22),
                        InkWell(
                          onTap: () async {
                            if (article.url.isEmpty) return;
                            await Clipboard.setData(
                              ClipboardData(text: article.url),
                            );
                          },
                          child: const Icon(Icons.link, size: 17),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _openArticle(article.url),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 194,
                          width: double.infinity,
                          child: article.localVideoPoster == null
                              ? NewsImage(article: article)
                              : Image.asset(
                                  article.localVideoPoster!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (article.localVideoPoster != null)
                      const Text(
                        'National headlines from ABC News Catch up on the developing stories making headlines.',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 11,
                        ),
                      ),
                    const SizedBox(height: 22),
                    const Divider(color: Color(0xFFE6E6E6), thickness: 1),
                    const SizedBox(height: 20),
                    if (article.content != null && article.content!.isNotEmpty)
                      Text(
                        article.content!,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 16,
                          height: 1.55,
                          color: Color(0xFF2F2F2F),
                        ),
                      ),
                    if (article.url.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () => _openArticle(article.url),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Full Article'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final month = const [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ][local.month - 1];
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final min = local.minute.toString().padLeft(2, '0');
    final amPm = local.hour >= 12 ? 'PM' : 'AM';
    return '$month ${local.day}, ${local.year}, $hour:$min $amPm';
  }

  Future<void> _shareArticle(String url) async {
    if (url.isEmpty) return;
    try {
      await ExternalArticleOpener.share(url);
    } on PlatformException {
      await Clipboard.setData(ClipboardData(text: url));
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: url));
    }
  }

  Future<void> _openArticle(String url) async {
    if (url.isEmpty) return;
    try {
      await ExternalArticleOpener.open(url);
    } on PlatformException {
      await Clipboard.setData(ClipboardData(text: url));
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: url));
    }
  }
}
