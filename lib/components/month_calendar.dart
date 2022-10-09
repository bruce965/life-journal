import 'package:flutter/material.dart';

import '../data/app_db_context.dart';
import '../data/date_only.dart';
import '../data/models/journal_entry.dart';
import '../pages/edit_entry_page.dart';

@immutable
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.date,
  });

  final DateTime date;

  // TODO: must be refreshed when returning from another page, because data
  //  might have been edited. Find a way to detect the event and refresh.

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final firstDayOfWeek = localizations.firstDayOfWeekIndex;
    final headers = Iterable.generate(7, (i) => (7 + firstDayOfWeek + i) % 7);

    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          childAspectRatio: 1.5,
          crossAxisCount: 7,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ...headers.map((w) => Container(
                  alignment: Alignment.center,
                  child: Text(localizations.narrowWeekdays[w]),
                )),
          ],
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            reverse: true,
            //crossAxisCount: 7,
            //crossAxisSpacing: 2,
            //mainAxisSpacing: 2,
            itemBuilder: (context, i) {
              if (i == 0) {
                // over-scroll
                return const SizedBox(height: 64);
              }

              return _MonthBlock(
                date: DateTime(date.year, date.month - i + 1),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonthBlock extends StatelessWidget {
  const _MonthBlock({
    //super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);

    final firstDayOfWeek = localizations.firstDayOfWeekIndex;

    final start = DateTime(date.year, date.month);
    //final end = DateTime(start.year, start.month + 1, 0);

    final daysBefore = (7 + start.weekday - firstDayOfWeek) % 7;
    final daysCount = DateTime(start.year, start.month + 1, 0).day;
    //final daysAfter = (6 - end.weekday + firstDayOfWeek) % 7;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(4, 32, 4, 16),
          child: Text(
            localizations.formatMonthYear(start).toUpperCase(),
            style: theme.textTheme.headlineSmall,
          ),
        ),
        FutureBuilder(
          future: _loadEntries(context),
          builder: (context, snapshot) {
            final Map<DateOnly, JournalEntry> entryByDay = {};
            for (final e in snapshot.data ?? const <JournalEntry>[]) {
              entryByDay[e.date] = e;
            }

            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ...Iterable.generate(daysBefore, (i) => const SizedBox()),
                ...Iterable.generate(
                  daysCount,
                  (d) => _DayCell(
                    date: DateTime(start.year, start.month, d + 1),
                    entry: entryByDay[DateOnly(start.year, start.month, d + 1)],
                  ),
                ),
                //...Iterable.generate(daysAfter, (i) => const SizedBox()),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<Iterable<JournalEntry>> _loadEntries(BuildContext context) async {
    debugPrint("Loading journal entries for month $date...");

    final db = AppDbContext.of(context)!;
    final entries = await db.journalEntries.query(
      where: 'date >= ? AND date < ?',
      whereArgs: [
        DateOnly(date.year, date.month, 1).value,
        DateOnly.fromDate(DateTime(date.year, date.month + 1)).value,
      ],
    );

    debugPrint("Loaded journal entries for month $date.");

    return entries;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    //super.key,
    required this.date,
    required this.entry,
  });

  final DateTime date;
  final JournalEntry? entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late final baseColor = theme.brightness == Brightness.dark
        ? const Color(0x22ffffff)
        : const Color(0x22000000);

    return Material(
      color: (entry?.text ?? "").isEmpty ? baseColor : Colors.green,
      textStyle: TextStyle(color: Colors.white), // TODO
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditEntryPage(date: date),
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Text(date.day.toString()),
        ),
      ),
    );
  }
}
