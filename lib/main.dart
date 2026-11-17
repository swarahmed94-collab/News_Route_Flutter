import 'package:flutter/material.dart';

import 'data/news_repository.dart';
import 'screens/news_shell.dart';
import 'state/news_app_state.dart';

const String newsApiKey = String.fromEnvironment('NEWS_API_KEY');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = NewsAppState(NewsRepository(apiKey: newsApiKey));
  runApp(NewsRouteApp(state: state));
}

class NewsRouteApp extends StatefulWidget {
  const NewsRouteApp({super.key, required this.state});
  final NewsAppState state;

  @override
  State<NewsRouteApp> createState() => _NewsRouteAppState();
}

class _NewsRouteAppState extends State<NewsRouteApp> {
  @override
  void dispose() {
    widget.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, child) {
        return MaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          themeMode: widget.state.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: false,
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF171717),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.dark,
            ),
            useMaterial3: false,
            fontFamily: 'Roboto',
          ),
          home: NewsShell(state: widget.state),
        );
      },
    );
  }
}
