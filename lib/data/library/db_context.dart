import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../utility/inherited_data.dart';
import 'db_config.dart';
import 'db_set.dart';
import 'db_table_config.dart';
import 'db_table_upgrade_info.dart';
import 'db_upgrade_info.dart';
import 'internal/version.dart';

abstract class DbContext {
  @protected
  late DbConfig config;

  FutureOr<Database> get database => _database!;
  FutureOr<Database>? _database;

  final _version = DbSet<Version>();

  late final Iterable<DbTableConfig<dynamic>> _systemTables = [
    Version.buildConfiguration(this, _version),
  ];

  DbContext(String fileName, {bool readOnly = false}) {
    config = buildConfiguration();
    _database = _attachSetsAndOpenDatabase(
        fileName, readOnly); // this is assigned first
  }

  static DbContext? of(BuildContext context) {
    return InheritedData.of<DbContext>(context)?.current;
  }

  @protected
  DbConfig buildConfiguration();

  Future<Database> _attachSetsAndOpenDatabase(
      String fileName, bool readOnly) async {
    final path = join(await getDatabasesPath(), fileName);

    debugPrint("Opening database: $path");

    final database = await openDatabase(
      path,
      version: 1,
      readOnly: readOnly,
      onConfigure: (db) {
        debugPrint("Configuring database: $path");

        _database = db; // this is assigned second

        final tables = [
          ..._systemTables,
          ...config.tables,
        ];

        for (final t in tables) {
          t.dbSet.attachToContext(this, t);
        }

        return onConfigure();
      },
      onCreate: (db, version) {
        debugPrint("Creating database: $path");

        return onCreate(version);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        final info = DbUpgradeInfo(
          oldVersion: oldVersion,
          newVersion: newVersion,
        );

        debugPrint(
            "Upgrading database from v${info.oldVersion} to v${info.newVersion}: $path");

        return onUpgrade(info);
      },
      onDowngrade: (db, oldVersion, newVersion) {
        final info = DbUpgradeInfo(
          oldVersion: oldVersion,
          newVersion: newVersion,
        );

        debugPrint(
            "Downgrading database from v${info.oldVersion} to v${info.newVersion}: $path");

        return onDowngrade(info);
      },
      onOpen: (db) {
        debugPrint("Database opened: $path");

        return onOpen();
      },
    );

    return database;
  }

  Future<void> onConfigure() async {}

  Future<void> onCreate(version) async {
    final tables = [
      ..._systemTables,
      ...config.tables,
    ];

    for (final table in tables) {
      await table.onCreate(this);

      await _version.insert(
        record: Version(
          table: table.name,
          version: table.version,
        ),
      );
    }
  }

  Future<void> onUpgrade(DbUpgradeInfo upgrade) =>
      _onUpdateVersion(upgrade, isUpgrade: true);

  Future<void> onDowngrade(DbUpgradeInfo downgrade) =>
      _onUpdateVersion(downgrade, isUpgrade: false);

  Future<void> onOpen() async {}

  Future<void> _onUpdateVersion(DbUpgradeInfo update,
      {required bool isUpgrade}) async {
    final tables = [
      ..._systemTables,
      ...config.tables,
    ];

    final tableVersionsResults = await _version.query(
      columns: ['table', 'version'],
      where: 'table IN ?',
      whereArgs: [
        tables.map((t) => t.name),
      ],
    );

    final tableVersions = <String, Version>{};
    for (final r in tableVersionsResults) {
      tableVersions[r.table] = r;
    }

    for (final table in tables) {
      final oldVersion = tableVersions[table.name];
      if (table.version == oldVersion?.version) {
        continue;
      }

      final info = DbTableUpgradeInfo(
        oldDbVersion: update.oldVersion,
        newDbVersion: update.newVersion,
        oldTableVersion: oldVersion?.version,
        newTableVersion: table.version,
      );

      if (isUpgrade) {
        await table.onUpgrade(this, info);
      } else {
        await table.onDowngrade(this, info);
      }

      await _version.insert(
        conflictAlgorithm: ConflictAlgorithm.replace,
        record: Version(
          id: oldVersion?.id,
          table: table.name,
          version: table.version,
        ),
      );
    }

    // TODO: delete tables that don't exist anymore, and remove records from __version.
  }

  Future<void> createTable(DbTableConfig<dynamic> table) async {
    final db = await database;

    debugPrint("Creating table: ${table.name}");

    return db.execute(
        'CREATE TABLE ${_escapeIdentifier(table.name)}(${table.columns.map((c) => [
              _escapeIdentifier(c.name),
              c.type,
              c.primaryKey ? 'PRIMARY KEY' : null,
              c.autoIncrement ? 'AUTOINCREMENT' : null,
              c.notNull ? 'NOT NULL' : null,
            ].where((x) => x != null).join(' ')).join(', ')})');
  }

  Future<void> upgradeTable(
    DbTableConfig<dynamic> table,
    DbTableUpgradeInfo upgrade,
  ) async {
    final db = await database;

    debugPrint(
        "Upgrading table from v${upgrade.oldTableVersion} to v${upgrade.newTableVersion}: ${table.name}");

    // TODO
    throw UnimplementedError();
  }

  Future<void> downgradeTable(
    DbTableConfig<dynamic> table,
    DbTableUpgradeInfo downgrade,
  ) async {
    final db = await database;

    debugPrint(
        "Downgrading table from v${downgrade.oldTableVersion} to v${downgrade.newTableVersion}: ${table.name}");

    // TODO
    throw UnimplementedError();
  }

  String _escapeIdentifier(String str) {
    return '"${str.replaceAll('"', '""')}"';
  }
}
