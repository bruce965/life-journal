import 'package:flutter/foundation.dart';

import 'db_record.dart';
import 'db_type.dart';

@immutable
class DbColumnConfig<T extends DbRecord, TType> {
  final String name;
  final DbType<TType> type;
  final bool primaryKey;
  final bool autoIncrement;
  final bool notNull;

  final dynamic Function(T record) _getValue;
  final void Function(T record, TType value) _setValue;

  const DbColumnConfig({
    required this.name,
    required this.type,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.notNull = false,
    required TType Function(T record) getValue,
    required void Function(T record, TType value) setValue,
  }): _getValue = getValue, _setValue = setValue;

  TType getFrom(T record) {
    return _getValue(record);
  }

  void setTo(T record, TType value) {
    _setValue(record, value);
  }
}
