import 'package:flutter/material.dart';

import '../state/news_app_state.dart';

Future<void> showNewsDrawer({
  required BuildContext context,
  required NewsAppState state,
  required VoidCallback onHome,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Close',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: const Color(0xFF171717),
          child: SizedBox(
            width: 246,
            height: double.infinity,
            child: AnimatedBuilder(
              animation: state,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 230,
                      child: ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'News App',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        onHome();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 12, 15),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.home_outlined, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              state.label('Go To Home', 'الصفحة الرئيسية'),
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white54, height: 1, indent: 20, endIndent: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 18, 8),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.format_paint_outlined, color: Colors.white, size: 20),
                          const SizedBox(width: 7),
                          Text(
                            state.label('Theme', 'المظهر'),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    _DrawerDropdown<ThemeMode>(
                      value: state.themeMode,
                      items: const <DropdownMenuItem<ThemeMode>>[
                        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                        DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      ],
                      onChanged: (value) {
                        if (value != null) state.setThemeMode(value);
                      },
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 18, 8),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.language_outlined, color: Colors.white, size: 20),
                          const SizedBox(width: 7),
                          Text(
                            state.label('Language', 'اللغة'),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    _DrawerDropdown<String>(
                      value: state.language,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'العربية', child: Text('العربية')),
                      ],
                      onChanged: (value) {
                        if (value != null) state.setLanguage(value);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _DrawerDropdown<T> extends StatelessWidget {
  const _DrawerDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.white70, width: 0.7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: const Color(0xFF171717),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
