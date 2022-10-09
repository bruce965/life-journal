import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:life_journal/data/library/db_column_config.dart';
import 'package:life_journal/data/library/db_context.dart';
import 'package:life_journal/data/library/db_table_config.dart';
import 'package:life_journal/data/library/db_type.dart';
import 'package:sqflite/sqflite.dart';

import 'db_record.dart';

class DbSet<T extends DbRecord> {
  FutureOr<_Data<T>>? _data;

  DbSet();

  void attachToContext(DbContext? context, DbTableConfig<T>? config) {
    if (context == null || config == null) {
      _data = null;
    } else {
      _data = () async {
        final db = await context.database;
        return _Data<T>(db, config);
      }();
    }
  }

  Future<bool> insert({
    required T record,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    assert(_data != null);
    final data = await _data!;

    final Map<String, Object?> values = {};
    for (final c in data.table.columns) {
      final v = c.getFrom(record);

      //// exclude unset integer primary key
      //if (c.primaryKey && v == null) {
      //  continue;
      //}

      values[c.name] = v;
    }

    final id = await data.db.insert(
      data.table.name,
      values,
      conflictAlgorithm: conflictAlgorithm,
    );

    if (id == 0) {
      // TODO: how to check success if record doesn't have a primary key?

      return false;
    }

    data.rowId?.setTo(record, id);
    return true;
  }

  Future<Iterable<T>> query({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    assert(_data != null);
    final data = await _data!;

    final results = await data.db.query(
      data.table.name,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return results.map((s) {
      final r = data.table.createRecord();
      for (final c in data.columns(columns)) {
        c.setTo(r, s[c.name]);
      }
      return r;
    });
  }

  Future<void> update() async {
    assert(_data != null);
    final data = await _data!;

    // TODO
    throw UnimplementedError();
  }

  Future<void> delete() async {
    assert(_data != null);
    final data = await _data!;

    // TODO
    throw UnimplementedError();
  }
}

@immutable
class _Data<T extends DbRecord> {
  final Database db;
  final DbTableConfig<T> table;
  final DbColumnConfig<T, dynamic>? rowId;
  final Map<String, DbColumnConfig<T, dynamic>> _colByName;

  _Data(this.db, this.table)
      : _colByName = {for (final c in table.columns) c.name: c},
      rowId = table.columns.firstWhere((c) => c.primaryKey && c.type == DbType.integer);

  Iterable<DbColumnConfig<T, dynamic>> columns(List<String>? names) {
    if (names == null) {
      return table.columns;
    }

    return names.map((c) => _colByName[c]).whereType();
  }
}
