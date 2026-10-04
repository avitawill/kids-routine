/// Local calendar day as `yyyy-MM-dd`, used to group RunLog and StarLedger rows.
String dateKey(DateTime t) {
  final l = t.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)}';
}
