import 'package:flutter/material.dart';

import '../data/news_repository.dart';
import '../models/news_article.dart';
import '../models/news_category.dart';
import '../widgets/article_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.repository,
    required this.onArticleTap,
  });

  final NewsRepository repository;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<NewsArticle> _articles = const [];
  bool _loading = true;
  String? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _fetch('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetch(String query) async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final articles = query.trim().isEmpty
          ? await widget.repository.headlines(NewsCategory.all.first)
          : await widget.repository.search(query.trim());
      if (!mounted || generation != _generation) return;
      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fg = dark ? Colors.white : Colors.black;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 11),
          child: Container(
            height: 43,
            decoration: BoxDecoration(
              border: Border.all(color: fg, width: 0.7),
              borderRadius: BorderRadius.circular(9),
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(color: fg, fontSize: 14),
              textInputAction: TextInputAction.search,
              onSubmitted: _fetch,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 10),
                hintText: 'Search',
                hintStyle: TextStyle(color: fg),
                prefixIcon: Icon(Icons.search, color: fg, size: 20),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close, color: fg, size: 20),
                  onPressed: () {
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                    _fetch('');
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(_error!, textAlign: TextAlign.center),
                      ),
                    )
                  : _articles.isEmpty
                      ? const SizedBox.expand()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                          itemCount: _articles.length,
                          itemBuilder: (context, i) => ArticleCard(
                            article: _articles[i],
                            onTap: () => widget.onArticleTap(_articles[i]),
                          ),
                        ),
        ),
      ],
    );
  }
}
