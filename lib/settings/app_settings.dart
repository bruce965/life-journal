import 'package:flutter/material.dart';

import '../utility/inherited_data.dart';

const Locale keepCurrentLocale = _LocaleGuard();

@immutable
class AppSettings {
  const AppSettings({
    required this.useSystemTheme,
    required this.darkMode,
    required this.locale,
  });

  final bool useSystemTheme;
  final bool darkMode;
  final Locale? locale;

  ThemeMode get themeMode => useSystemTheme
      ? ThemeMode.system
      : darkMode
          ? ThemeMode.dark
          : ThemeMode.light;

  static InheritedData<AppSettings>? of(BuildContext context) {
    return InheritedData.of<AppSettings>(context);
  }

  AppSettings copyWith({
    bool? useSystemTheme,
    bool? darkMode,
    Locale? locale = keepCurrentLocale,
  }) =>
      AppSettings(
        useSystemTheme: useSystemTheme ?? this.useSystemTheme,
        darkMode: darkMode ?? this.darkMode,
        locale: (keepCurrentLocale == locale) ? this.locale : locale,
      );
}

class _LocaleGuard implements Locale {
  const _LocaleGuard();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError("Not supported");
}
