import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/month_calendar.dart';
import 'edit_entry_page.dart';

@immutable
class CalendarPage extends StatelessWidget {
  const CalendarPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendar),
      ),
      body: Center(
        child: MonthCalendar(date: DateTime.now()),
        //child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        //  children: const [
        //  ],
        //),
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
