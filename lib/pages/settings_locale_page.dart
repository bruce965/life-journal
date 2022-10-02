import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

import '../settings/app_settings.dart';
import '../utility/inherited_data.dart';

@immutable
class SettingsLocalePage extends StatelessWidget {
  const SettingsLocalePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final settings = InheritedData.of<AppSettings>(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.locale),
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
            tiles: [
              SettingsTile(
                title: Text(l10n.localeAuto),
                value: Text(l10n.localeAutoDescription),
                enabled: settings.current.locale != null,
                onPressed: (context) {
                  settings.set(settings.current.copyWith(
                    locale: null,
                  ));
                },
              ),
              ...AppLocalizations.supportedLocales
                  .map((locale) => _Option(locale)),
            ],
          ),
        ],
      ),
    );
  }
}

// HACK: the author of the settings_ui library decided to force the use
//  of the useless AbstractSettingsTile class.
class _Option extends AbstractSettingsTile {
  const _Option(this.locale);

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: locale,
      child: _OptionInner(locale),
    );
  }
}

class _OptionInner extends StatelessWidget {
  const _OptionInner(this.locale);

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = InheritedData.of<AppSettings>(context)!;

    return SettingsTile(
      title: Text(l10n.localizedName),
      value: Text(locale.toLanguageTag()),
      enabled: settings.current.locale != locale,
      onPressed: (context) {
        settings.set(settings.current.copyWith(
          locale: locale,
        ));
      },
    );
  }
}
