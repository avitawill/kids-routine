import 'enums.dart';

/// Where a pack task goes when the pack is turned on. The parent can reorder
/// afterwards.
class PackPlacement {
  const PackPlacement.first(this.routine, this.key)
    : before = null,
      after = null,
      last = false;
  const PackPlacement.last(this.routine, this.key)
    : before = null,
      after = null,
      last = true;
  const PackPlacement.before(this.routine, this.key, String anchor)
    : before = anchor,
      after = null,
      last = false;
  const PackPlacement.after(this.routine, this.key, String anchor)
    : after = anchor,
      before = null,
      last = false;

  final RoutineType routine;
  final String key;
  final String? before;
  final String? after;
  final bool last;

  /// Index to insert [key] at in a routine whose task keys are [keys].
  /// Falls back to the end when the anchor task isn't in the routine.
  int indexIn(List<String?> keys) {
    if (before != null) {
      final i = keys.indexOf(before);
      return i < 0 ? keys.length : i;
    }
    if (after != null) {
      final i = keys.indexOf(after);
      return i < 0 ? keys.length : i + 1;
    }
    return last ? keys.length : 0;
  }
}

/// Applied in this order. Modeh Ani is said on waking, then Netilat Yadayim,
/// both before getting out of bed.
const jewishPackPlacements = [
  PackPlacement.first(RoutineType.morning, 'modeh_ani'),
  PackPlacement.after(RoutineType.morning, 'netilat_yadayim', 'modeh_ani'),
  PackPlacement.after(RoutineType.morning, 'birchot_hashachar', 'get_dressed'),
  PackPlacement.before(RoutineType.morning, 'bracha_before_food', 'breakfast'),
  PackPlacement.before(RoutineType.noon, 'bracha_before_food', 'lunch'),
  PackPlacement.last(RoutineType.evening, 'shema_bedtime'),
];
