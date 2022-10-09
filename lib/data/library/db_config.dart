import 'package:flutter/cupertino.dart';

import 'db_context.dart';
import 'db_table_config.dart';

@immutable
class DbConfig<T extends DbContext> {
  final int version;
  final Iterable<DbTableConfig<dynamic>> tables;

  DbConfig({
    required this.version,
    required Iterable<DbTableConfig<dynamic>> tables,
  }) : tables = [...tables];
}
