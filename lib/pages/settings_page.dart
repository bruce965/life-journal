import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:life_journal/pages/settings_locale_page.dart';
import 'package:settings_ui/settings_ui.dart';

import '../settings/app_settings.dart';
import '../utility/inherited_data.dart';

@immutable
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final settings = InheritedData.of<AppSettings>(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          titleTextColor: theme.colorScheme.secondary,
        ),
        darkTheme: SettingsThemeData(
          titleTextColor: theme.colorScheme.secondary,
        ),
        sections: [
          SettingsSection(
            title: Text(l10n.settingsLanguage),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(l10n.locale),
                value: Text(l10n.localizedName),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsLocalePage(),
                  ));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(l10n.settingsTheme),
            tiles: [
              SettingsTile.switchTile(
                initialValue: settings.current.useSystemTheme,
                leading: const Icon(Icons.format_paint),
                title: Text(l10n.settingsThemeSystem),
                onToggle: (value) {
                  settings.set(settings.current.copyWith(
                    useSystemTheme: value,
                  ));
                },
              ),
              SettingsTile.switchTile(
                initialValue: settings.current.darkMode,
                leading: const Icon(Icons.dark_mode),
                title: Text(l10n.settingsThemeDark),
                enabled: !settings.current.useSystemTheme,
                onToggle: (value) {
                  settings.set(settings.current.copyWith(
                    darkMode: value,
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
