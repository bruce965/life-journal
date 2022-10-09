import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_journal/settings/app_settings.dart';
import 'package:life_journal/utility/inherited_data.dart';
import 'package:sqflite/sqflite.dart';

import 'data/app_db_context.dart';
import 'pages/home_page.dart';

void main() {
  // required by sqflite
  WidgetsFlutterBinding.ensureInitialized();

  assert(() {
    // enable sqflite logs in debug mode
    Sqflite.setDebugModeOn();
    return true;
  }());

  const initialSettings = AppSettings(
    useSystemTheme: true,
    darkMode: false,
    locale: null,
  );

  final dbContext = AppDbContext('app_data.db');

  runApp(InheritedData.provider(
    data: [
      InheritedData<AppDbContext>(dbContext),
      InheritedData<AppSettings>.dynamic(initialSettings),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = InheritedData.of<AppSettings>(context)!;

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      themeMode: settings.current.themeMode,
      theme: _makeTheme(isDark: false),
      darkTheme: _makeTheme(isDark: true),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settings.current.locale,
      home: const HomePage(),
    );
  }

  static ThemeData _makeTheme({required bool isDark}) {
    const primary = Colors.green;
    const secondary = Colors.amber;

    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: primary,
            secondary: secondary,
          )
        : const ColorScheme.light(
            primary: primary,
            secondary: secondary,
          );

    //final colorScheme = ColorScheme.fromSwatch(
    //    primarySwatch: primarySwatch,
    //    primaryColorDark: primarySwatch[700],
    //    accentColor: secondary,
    //    //cardColor: ...,
    //    backgroundColor: isDark ? Colors.grey[800]! : Colors.white,
    //    //errorColor: ...,
    //    brightness: brightness,
    //).copyWith(
    //  secondaryVariant: isDark ? secondary[700]! : primarySwatch[700]!,
    //);

    final theme = ThemeData.from(
      colorScheme: colorScheme,
      //switchTheme: SwitchThemeData(
      //  trackColor: MaterialStateProperty.resolveWith((states) => Colors.amber),
      //  thumbColor: MaterialStateProperty.resolveWith((states) => Colors.amber),
      //),
    );

    return theme;
  }
}
