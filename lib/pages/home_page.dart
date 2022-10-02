import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:life_journal/pages/edit_entry_page.dart';

import 'calendar_page.dart';
import 'settings_page.dart';

@immutable
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("User"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                child: Text("U"),
              ),
            ),
            ListTile(
              title: Text(l10n.calendar),
              trailing: const Icon(Icons.calendar_month),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CalendarPage(),
                ));
              },
            ),
            const Divider(),
            ListTile(
              title: Text(l10n.settings),
              trailing: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello, World!"),
            Switch(value: true, onChanged: (value) {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditEntryPage(date: DateTime.now()),
          ));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
