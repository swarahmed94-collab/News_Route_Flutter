import 'package:flutter/material.dart';

import '../models/news_article.dart';
import '../models/news_category.dart';
import '../state/news_app_state.dart';
import '../widgets/article_preview_sheet.dart';
import '../widgets/news_drawer.dart';
import 'article_screen.dart';
import 'category_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class NewsShell extends StatefulWidget {
  const NewsShell({super.key, required this.state});
  final NewsAppState state;

  @override
  State<NewsShell> createState() => _NewsShellState();
}

enum _Page { home, category, search }

class _NewsShellState extends State<NewsShell> {
  _Page _page = _Page.home;
  NewsCategory _category = NewsCategory.all.first;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1050), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  void _goHome() => setState(() => _page = _Page.home);

  void _goCategory(NewsCategory category) {
    setState(() {
      _category = category;
      _page = _Page.category;
    });
  }

  void _goSearch() => setState(() => _page = _Page.search);

  void _openArticle(NewsArticle article) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ArticleScreen(article: article),
      ),
    );
  }

  void _onArticleTap(NewsArticle article) {
    showArticlePreview(
      context: context,
      article: article,
      onFullArticle: () => _openArticle(article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = dark ? Colors.white : const Color(0xFF171717);
    if (_showSplash) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/branding/microphone_${dark ? 'dark' : 'light'}.png',
                width: 114,
                height: 164,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.9),
              child: Image.asset(
                'assets/branding/signature_${dark ? 'dark' : 'light'}.png',
                width: 121,
                height: 71,
              ),
            ),
          ],
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (_page != _Page.home) {
          _goHome();
          return false;
        }
        return true;
      },
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 69,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu, size: 23, color: foreground),
                    onPressed: () => showNewsDrawer(
                      context: context,
                      state: widget.state,
                      onHome: _goHome,
                    ),
                  ),
                  Text(
                    switch (_page) {
                      _Page.home => widget.state.label('Home', 'الرئيسية'),
                      _Page.category => widget.state.isArabic
                          ? _category.arabicLabel
                          : _category.label,
                      _Page.search => '',
                    },
                    style: TextStyle(fontSize: 20, color: foreground),
                  ),
                  IconButton(
                    onPressed: _goSearch,
                    icon: Icon(Icons.search, size: 27, color: foreground),
                  ),
                ],
              ),
            ),
            Expanded(
              child: switch (_page) {
                _Page.home => HomeScreen(
                    state: widget.state,
                    onCategoryTap: _goCategory,
                  ),
                _Page.category => CategoryScreen(
                    key: ValueKey<String>(_category.key),
                    category: _category,
                    repository: widget.state.repository,
                    onArticleTap: _onArticleTap,
                  ),
                _Page.search => SearchScreen(
                    repository: widget.state.repository,
                    onArticleTap: _onArticleTap,
                  ),
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
