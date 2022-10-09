import '../app_db_context.dart';
import '../date_only.dart';
import '../library/db_column_config.dart';
import '../library/db_record.dart';
import '../library/db_table_config.dart';
import '../library/db_type.dart';

class JournalEntry extends DbRecord {
  int? id;
  DateOnly date;
  String text;

  JournalEntry({
    this.id,
    this.date = DateOnly.epoch,
    this.text = "",
  });

  @override
  String toString() => "JournalEntry{id: $id, date: $date, text: $text}";

  static DbTableConfig<JournalEntry> buildConfiguration(AppDbContext context) =>
      DbTableConfig<JournalEntry>(
        context.journalEntries,
        name: 'journal_entries',
        version: 1,
        createNew: () => JournalEntry(),
        columns: [
          DbColumnConfig(
            name: 'id',
            type: DbType.integer,
            primaryKey: true,
            notNull: true,
            getValue: (r) => r.id,
            setValue: (r, v) => r.id = v,
          ),
          DbColumnConfig(
            name: 'date',
            type: DbType.integer,
            notNull: true,
            getValue: (r) => r.date.value,
            setValue: (r, v) => r.date = DateOnly.fromValue(v),
          ),
          DbColumnConfig(
            name: 'text',
            type: DbType.text,
            notNull: true,
            getValue: (r) => r.text,
            setValue: (r, v) => r.text = v,
          )
        ],
      );
}
