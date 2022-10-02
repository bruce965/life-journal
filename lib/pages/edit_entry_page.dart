import 'package:flutter/material.dart';

@immutable
class EditEntryPage extends StatelessWidget {
  EditEntryPage({
    super.key,
    required DateTime date,
  }) : date = DateTime(date.year, date.month, date.day);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.formatShortDate(date)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Editing $date"),
          ],
        ),
      ),
    );
  }
}
