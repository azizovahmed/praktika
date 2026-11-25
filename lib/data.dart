import 'package:flutter/foundation.dart';
import 'models.dart';

/// Ilovaning ma'lumotlari. Hozircha faqat xotirada turadi:
/// ilova yopilsa, o'zgarishlar yo'qoladi.
/// (Qiyin vazifa: ma'lumotni saqlab qo'yish. TASKS.md ga qarang.)
class AppState extends ChangeNotifier {
  final List<Debt> debts = [
    Debt(name: 'Ali', amount: 1000000, lent: true, due: '2026-11-30', note: 'Ishdan qaytib beradi', date: '2026-10-30', pays: [Pay(200000, '2026-11-05')]),
    Debt(name: 'Vali', amount: 500000, lent: true, due: '2026-11-01', date: '2026-10-20'),
    Debt(name: 'Sardor', amount: 300000, lent: false, date: '2026-11-02'),
  ];

  final List<Tx> txs = [
    Tx(true, 2000000, 'Maosh', '2026-11-01'),
    Tx(false, 350000, 'Oziq-ovqat', '2026-11-03'),
    Tx(false, 120000, 'Transport', '2026-10-15'),
    Tx(true, 500000, 'Qo’shimcha ish', '2026-10-10'),
  ];

  /// Ro'yxatlarni o'zgartirgandan keyin shuni chaqiring, ekran yangilanadi.
  void changed() => notifyListeners();
}

final app = AppState();

/// Bugungi sana, "2026-11-17" ko'rinishida.
String today() => DateTime.now().toIso8601String().substring(0, 10);
