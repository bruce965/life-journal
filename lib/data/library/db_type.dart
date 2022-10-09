import 'dart:core';
import 'dart:core' as core;

import 'package:flutter/foundation.dart';

@immutable
class DbType<T> {
  static const DbType<core.int> int = DbType('INT');
  static const DbType<core.int> integer = DbType('INTEGER');
  static const DbType<core.int> tinyint = DbType('TINYINT');
  static const DbType<core.int> smallint = DbType('SMALLINT');
  static const DbType<core.int> mediumint = DbType('MEDIUMINT');
  static const DbType<core.int> bigint = DbType('BIGINT');
  static const DbType<core.int> unsignedBigInt = DbType('UNSIGNED BIG INT');
  static const DbType<core.int> int2 = DbType('INT2');
  static const DbType<core.int> int8 = DbType('INT8');

  static DbType<String> character(core.int size) => DbType('CHARACTER($size)');
  static DbType<String> varchar(core.int size) => DbType('VARCHAR($size)');
  static DbType<String> varyingCharacter(core.int size) => DbType('VARYING CHARACTER($size)');
  static DbType<String> nchar(core.int size) => DbType('NCHAR($size)');
  static DbType<String> nativeCharacter(core.int size) => DbType('NATIVE CHARACTER($size)');
  static DbType<String> nvarchar(core.int size) => DbType('NVARCHAR($size)');
  static const DbType<core.String> text = DbType('TEXT');
  static const DbType<core.String> clob = DbType('CLOB');

  static const DbType<Uint8List> blob = DbType('BLOB');

  static const DbType<core.double> real = DbType('REAL');
  static const DbType<core.double> double = DbType('DOUBLE');
  static const DbType<core.double> doublePrecision = DbType('DOUBLE PRECISION');
  static const DbType<core.double> float = DbType('FLOAT');

  static const DbType<core.double> numeric = DbType('NUMERIC');
  static DbType<String> decimal(core.int digits, core.int decimals) => DbType('DECIMAL($digits,$decimals)');
  static const DbType<bool> boolean = DbType('BOOLEAN');
  static const DbType<Object> date = DbType('DATE');
  static const DbType<Object> datetime = DbType('DATETIME');

  final String name;

  const DbType(this.name);

  @override
  bool operator ==(Object other) =>
      other is DbType &&
      runtimeType == other.runtimeType &&
      name == other.name;

  @override
  core.int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
