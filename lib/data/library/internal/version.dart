import '../db_column_config.dart';
import '../db_context.dart';
import '../db_record.dart';
import '../db_set.dart';
import '../db_table_config.dart';
import '../db_type.dart';

class Version extends DbRecord {
  int? id;
  String table;
  int version;

  Version({
    this.id,
    this.table = "",
    this.version = 0,
  });

  @override
  String toString() => "JournalEntry{id: $id, table: $table, version: $version}";

  static DbTableConfig<Version> buildConfiguration(DbContext context, DbSet<Version> versionDbSet) =>
      DbTableConfig<Version>(
        versionDbSet,
        name: '__version',
        version: 1,
        createNew: () => Version(),
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
            name: 'table',
            type: DbType.text,
            getValue: (r) => r.table,
            setValue: (r, v) => r.table = v,
          ),
          DbColumnConfig(
            name: 'version',
            type: DbType.integer,
            getValue: (r) => r.version,
            setValue: (r, v) => r.version = v,
          ),
        ],
      );
}
