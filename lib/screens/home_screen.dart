import 'package:flutter/material.dart';

import '../models/news_category.dart';
import '../state/news_app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.state,
    required this.onCategoryTap,
  });

  final NewsAppState state;
  final ValueChanged<NewsCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = dark ? Colors.white : const Color(0xFF171717);
    // The exported Figma screenshots use white cards on dark backgrounds,
    // and dark cards on white backgrounds.
    final imageSuffix = dark ? 'white' : 'dark';
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 28),
      children: <Widget>[
        Text(
          state.label('Good Morning', 'صباح الخير'),
          style: TextStyle(fontSize: 23, color: foreground, height: 1.2),
        ),
        const SizedBox(height: 6),
        Text(
          state.label('Here is Some News For You', 'إليك بعض الأخبار'),
          style: TextStyle(fontSize: 23, color: foreground, height: 1.3),
        ),
        const SizedBox(height: 19),
        ...NewsCategory.all.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => onCategoryTap(category),
              child: Semantics(
                button: true,
                label: '${category.label}, View All',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: AspectRatio(
                    aspectRatio: 363 / 199,
                    child: Image.asset(
                      'assets/cards/${category.key}_$imageSuffix.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
