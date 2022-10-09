import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:life_journal/data/library/db_column_config.dart';
import 'package:life_journal/data/library/db_context.dart';
import 'package:life_journal/data/library/db_set.dart';
import 'package:life_journal/data/library/db_table_upgrade_info.dart';

import 'db_record.dart';

@immutable
class DbTableConfig<T extends DbRecord> {
  final DbSet<T> dbSet;
  final String name;
  final int version;
  final Iterable<DbColumnConfig<T, dynamic>> columns;

  final T Function() _createNew;

  DbTableConfig(this.dbSet, {
    required this.name,
    required this.version,
    required T Function() createNew,
    required Iterable<DbColumnConfig<T, dynamic>> columns,
  }) : columns = columns.toList(), _createNew = createNew;

  T createRecord() {
    return _createNew();
  }

  FutureOr<void> onConfigure(DbContext db) {
    //return db.configureTable(this);
  }

  FutureOr<void> onCreate(DbContext db) {
    return db.createTable(this);
  }

  FutureOr<void> onUpgrade(DbContext db, DbTableUpgradeInfo upgrade) {
    return db.upgradeTable(this, upgrade);
  }

  FutureOr<void> onDowngrade(DbContext db, DbTableUpgradeInfo downgrade) {
    return db.downgradeTable(this, downgrade);
  }

  FutureOr<void> onOpen(DbContext db) {
    //return db.openTable(this);
  }
}
