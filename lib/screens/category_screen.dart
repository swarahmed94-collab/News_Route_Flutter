import 'package:flutter/material.dart';

import '../data/news_repository.dart';
import '../models/news_article.dart';
import '../models/news_category.dart';
import '../models/news_source.dart';
import '../widgets/article_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.category,
    required this.repository,
    required this.onArticleTap,
  });

  final NewsCategory category;
  final NewsRepository repository;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<NewsSource> _sources = const [];
  List<NewsArticle> _articles = const [];
  int _selectedSourceIndex = 0;
  bool _loading = true;
  String? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category.key != widget.category.key) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
      _sources = const [];
      _articles = const [];
      _selectedSourceIndex = 0;
    });
    try {
      final sources = await widget.repository.sources(widget.category);
      if (!mounted || generation != _generation) return;
      setState(() => _sources = sources);
      await _fetch(0, generation: generation);
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _fetch(int index, {int? generation}) async {
    final current = generation ?? ++_generation;
    setState(() {
      _selectedSourceIndex = index;
      _loading = true;
      _error = null;
    });
    try {
      final id = _sources.isEmpty ? '' : _sources[index].id;
      final articles = await widget.repository.headlines(
        widget.category,
        sourceId: id.isEmpty ? null : id,
      );
      if (!mounted || current != _generation) return;
      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || current != _generation) return;
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
        SizedBox(
          height: 54,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(15, 8, 10, 11),
            itemCount: _sources.length,
            separatorBuilder: (_, index) => const SizedBox(width: 18),
            itemBuilder: (context, i) {
              final selected = i == _selectedSourceIndex;
              return InkWell(
                onTap: () => _fetch(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selected ? fg : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _sources[i].name,
                        style: TextStyle(
                          fontSize: 14,
                          color: fg,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : _articles.isEmpty
                      ? const SizedBox.expand()
                      : RefreshIndicator(
                          onRefresh: () => _fetch(_selectedSourceIndex),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 11, 15, 24),
                            itemCount: _articles.length,
                            itemBuilder: (context, index) {
                              final article = _articles[index];
                              return ArticleCard(
                                article: article,
                                onTap: () => widget.onArticleTap(article),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}
