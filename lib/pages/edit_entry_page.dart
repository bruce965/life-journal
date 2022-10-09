import 'dart:async';

import 'package:flutter/material.dart';
import 'package:life_journal/data/app_db_context.dart';
import 'package:life_journal/data/date_only.dart';
import 'package:life_journal/data/models/journal_entry.dart';
import 'package:sqflite/sqlite_api.dart';

@immutable
class EditEntryPage extends StatelessWidget {
  EditEntryPage({
    super.key,
    required DateTime date,
  }) : date = DateTime(date.year, date.month, date.day);

  final DateTime date;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.formatShortDate(date)),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: _loadEntry(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              debugPrint("Error loading journal entry: ${snapshot.error}");

              // TODO: report error to user and allow to recover.
            }

            final entry = snapshot.data ??
                JournalEntry(
                  date: DateOnly.fromDate(date),
                  text: "",
                );

            _controller.text = entry.text;

            return TextField(
              controller: _controller,
              maxLength: null,
              autofocus: true,
              decoration: null,
              onSubmitted: (value) {
                entry.text = _controller.text;

                _saveEntry(context, entry);
              },
            );
          },
        ),
      ),
    );
  }

  Future<JournalEntry?> _loadEntry(BuildContext context) async {
    debugPrint("Loading journal entry...");

    final db = AppDbContext.of(context)!;
    final entries = await db.journalEntries.query(
      where: 'date = ?',
      whereArgs: [
        DateOnly.fromDate(date).value,
      ],
    );

    final entry = entries.isEmpty ? null : entries.first;

    debugPrint("Journal entry: $entry");

    return entry;
  }

  Future<void> _saveEntry(BuildContext context, JournalEntry entry) async {
    debugPrint("Saving journal entry: ${entry.date}");

    final db = AppDbContext.of(context)!;

    final ok = await db.journalEntries.insert(
      record: entry,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (ok) {
      debugPrint("Journal entry saved: ${entry.id}");
    } else {
      debugPrint("Journal entry save failed.");
    }
  }
}
