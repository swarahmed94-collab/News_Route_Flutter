import 'package:flutter/material.dart';

import '../data/news_repository.dart';

class NewsAppState extends ChangeNotifier {
  NewsAppState(this.repository);
  final NewsRepository repository;

  ThemeMode _themeMode = ThemeMode.dark;
  String _language = 'English';

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get isArabic => _language == 'العربية';

  void setThemeMode(ThemeMode next) {
    if (next == _themeMode) return;
    _themeMode = next;
    notifyListeners();
  }

  void setLanguage(String next) {
    if (next == _language) return;
    _language = next;
    notifyListeners();
  }

  String label(String english, String arabic) => isArabic ? arabic : english;

  @override
  void dispose() {
    repository.dispose();
    super.dispose();
  }
}
