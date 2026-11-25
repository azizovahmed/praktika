/// To'lov: qarzdan qaytarilgan (yoki to'langan) summa.
class Pay {
  Pay(this.amount, this.date);
  final double amount;
  final String date; // "2026-11-05" ko'rinishida (yil-oy-kun)
}

/// Qarz yozuvi.
class Debt {
  Debt({
    required this.name,
    required this.amount,
    required this.lent,
    this.due,
    this.note = '',
    required this.date,
    List<Pay>? pays,
  }) : pays = pays ?? [];

  String name;
  double amount; // qarzning jami summasi
  bool lent; // true: men qarz berdim (menga qaytariladi), false: men qarz oldim
  String? due; // qaytarish muddati, masalan "2026-11-30" (bo'lmasligi mumkin)
  String note;
  String date; // qarz yozilgan sana
  List<Pay> pays;
}

/// Kirim yoki chiqim yozuvi.
class Tx {
  Tx(this.income, this.amount, this.note, this.date);
  bool income; // true: kirim, false: chiqim
  double amount;
  String note;
  String date; // "2026-11-03"
}

/// Hisobotdagi bitta oy qatori.
class MonthRow {
  MonthRow(this.month, this.income, this.expense);
  final String month; // "2026-11"
  final double income;
  final double expense;
  double get diff => income - expense;
}
