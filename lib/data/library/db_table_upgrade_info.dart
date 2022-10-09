import 'package:flutter/foundation.dart';

@immutable
class DbTableUpgradeInfo {
  final int? oldDbVersion;
  final int newDbVersion;
  final int? oldTableVersion;
  final int newTableVersion;

  const DbTableUpgradeInfo({
    required this.oldDbVersion,
    required this.newDbVersion,
    required this.oldTableVersion,
    required this.newTableVersion,
  });
}
