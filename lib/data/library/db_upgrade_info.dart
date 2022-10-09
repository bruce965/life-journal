import 'package:flutter/foundation.dart';

@immutable
class DbUpgradeInfo {
  final int oldVersion;
  final int newVersion;

  const DbUpgradeInfo({
    required this.oldVersion,
    required this.newVersion,
  });
}
