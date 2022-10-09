import 'package:flutter/foundation.dart';

/// Date without time, between `0000-01-01` and `9999-12-31`.
@immutable
class DateOnly implements Comparable<DateOnly> {
  /// Value as a readable sortable integer number.
  ///
  /// For the date `2022-01-23`, this value is `20220123`.
  final int value;

  int get year => value ~/ 10000;
  int get month => (value ~/ 100) % 100;
  int get day => value % 100;

  DateTime get date => DateTime(year, month, day);

  static const DateOnly epoch = DateOnly(1970, 1, 1);

  const DateOnly(int year, int month, int day)
      : assert(year >= 0 && year <= 9999),
        assert(month >= 1 && month <= 12),
        assert(day >= 1 && day <= 31),
        assert((month != 4 && month != 6 && month != 9 && month != 11) ||
            day <= 30),
        assert(month != 2 ||
            day <=
                ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
                    ? 29
                    : 28)),
        value = year * 10000 + month * 100 + day;

  const DateOnly.fromValue(int value)
      : this(
          value ~/ 10000,
          (value ~/ 100) % 100,
          value % 100,
        );

  DateOnly.fromDate(DateTime date)
    : this(date.year, date.month, date.day);

  @override
  int compareTo(DateOnly other) => value - other.value;

  bool operator <=(DateOnly other) => value <= other.value;

  bool operator >=(DateOnly other) => value >= other.value;

  bool operator <(DateOnly other) => value < other.value;

  bool operator >(DateOnly other) => value > other.value;

  @override
  bool operator ==(Object other) =>
      other is DateOnly &&
      runtimeType == other.runtimeType &&
      value == other.value;

  @override
  int get hashCode => value;

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
