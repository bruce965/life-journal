import 'package:flutter/widgets.dart';

import '../utility/inherited_data.dart';
import 'library/db_config.dart';
import 'library/db_context.dart';
import 'library/db_set.dart';
import 'models/journal_entry.dart';

class AppDbContext extends DbContext {
  final journalEntries = DbSet<JournalEntry>();

  AppDbContext(super.fileName);

  static AppDbContext? of(BuildContext context) {
    return InheritedData.of<AppDbContext>(context)?.current;
  }

  @override
  DbConfig buildConfiguration() {
    return DbConfig(
      version: 1,
      tables: [
        JournalEntry.buildConfiguration(this),
      ],
    );
  }
}
