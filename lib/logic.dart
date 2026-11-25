import 'models.dart';

// =====================================================================
//  O'QUVCHI UCHUN
//  Shu fayldagi funksiyalarni o'zingiz yozasiz. Har birining tepasida
//  nima qilishi va misollar bor. Funksiyani yozgach, terminalda:
//
//      flutter test
//
//  buyrug'ini bering. Testlar qaysi vazifa to'g'ri, qaysi biri xato
//  ekanini ko'rsatadi. Ilovaning o'zi ham funksiyalar to'g'ri
//  yozilgan sari to'g'ri ko'rina boshlaydi.
//
//  Batafsil: TASKS.md
// =====================================================================

/// 1-VAZIFA (oson): Qarzning qolgan summasi.
///
/// qolgan = qarz summasi - barcha to'lovlar yig'indisi.
/// Natija 0 dan kam bo'lmasin.
///
/// Misollar:
///   qarz 1000, to'lov yo'q          -> 1000
///   qarz 1000, to'lovlar 300 va 200 -> 500
///   qarz 1000, to'lov 1200          -> 0
double remaining(Debt d) {
  // TODO: shu yerga yozing
  return 0;
}

/// 2-VAZIFA (oson): "Menga qarzdorlar" jami qoldig'i.
///
/// Faqat `lent == true` qarzlarning qolgan summalari yig'indisi
/// (1-vazifadagi `remaining` funksiyasidan foydalaning).
double totalLent(List<Debt> debts) {
  // TODO
  return 0;
}

/// 2-VAZIFA (oson): "Men qarzdorman" jami qoldig'i.
///
/// Faqat `lent == false` qarzlarning qolgan summalari yig'indisi.
double totalBorrowed(List<Debt> debts) {
  // TODO
  return 0;
}

/// 3-VAZIFA (oson): Kassa balansi = jami kirim - jami chiqim.
///
/// Misol: kirimlar 1000 va 500, chiqim 300 -> 1200.
double cashBalance(List<Tx> txs) {
  // TODO
  return 0;
}

/// 4-VAZIFA (oson): Sof holat = kassa + menga qarzdorlar - mening qarzlarim.
///
/// Misol: kassa 700, menga qarzdorlar 1100, mening qarzlarim 700 -> 1100.
double netPosition(List<Debt> debts, List<Tx> txs) {
  // TODO
  return 0;
}

/// 5-VAZIFA (o'rta): Pulni chiroyli yozish.
///
/// Uch xonadan bo'sh joy qo'yiladi, oxiriga "so’m" yoziladi.
/// DIQQAT: "so’m" dagi belgi ’ (tepada egri vergul), oddiy ' emas.
/// Kasr qismi yaxlitlanadi. Manfiy son oldida "-" turadi.
///
/// Misollar:
///   0         -> "0 so’m"
///   999       -> "999 so’m"
///   1000      -> "1 000 so’m"
///   1234567   -> "1 234 567 so’m"
///   -145000   -> "-145 000 so’m"
String formatMoney(num n) {
  // TODO: hozir bo'sh joysiz chiqadi, uni to'g'rilang
  return '${n.round()} so’m';
}

/// 6-VAZIFA (o'rta): Ism bo'yicha qidiruv.
///
/// Qarz nomida `query` qatnashsa, qarz natijaga kiradi.
///  - katta-kichik harf farqi yo'q ("ALI" ham "Ali" ni topadi)
///  - `query` ning boshidagi/oxiridagi bo'sh joylar hisobga olinmaydi
///  - `query` bo'sh bo'lsa, hamma qarz qaytadi
///
/// Misol: ismlar Ali, Aliyev, Vali, Sardor. Qidiruv "ali" -> Ali, Aliyev, Vali.
List<Debt> searchDebts(List<Debt> debts, String query) {
  // TODO: hozir hamma qarzni qaytaradi, filtr qo'shing
  return debts;
}

/// 7-VAZIFA (o'rta): Qarz muddati o'tganmi?
///
/// `today` va `d.due` "2026-11-17" ko'rinishida. Matn sifatida
/// solishtirsa bo'ladi (nima uchun ishlashini o'zingiz o'ylab ko'ring).
///
/// Muddati o'tgan = muddat bor, muddat bugundan KICHIK va qarz hali
/// to'liq to'lanmagan. Muddat aynan bugun bo'lsa, hali o'tmagan.
///
/// Misollar (bugun 2026-11-02):
///   muddat 2026-11-01, to'lanmagan -> true
///   muddat 2026-11-02              -> false (bugun, hali o'tmagan)
///   muddat yo'q                    -> false
///   muddat 2026-11-01, to'liq to'langan -> false
bool isOverdue(Debt d, String today) {
  // TODO
  return false;
}

/// 8-VAZIFA (o'rta): Qarzga to'lov qo'shish.
///
/// Tekshiring:
///  - `amount` 0 yoki manfiy bo'lsa  -> "Summani kiriting." qaytaring
///  - `amount` qolgan summadan katta bo'lsa -> "Summa qoldiqdan katta." qaytaring
/// Xato bo'lsa to'lov QO'SHILMAYDI. Hammasi joyida bo'lsa `d.pays` ga
/// `Pay(amount, date)` qo'shing va `null` qaytaring.
///
/// (null qaytarish "xato yo'q" degani.)
String? addPayment(Debt d, double amount, String date) {
  // TODO
  return 'Hali yozilmagan (TODO)';
}

/// 9-VAZIFA (qiyinroq): Oxirgi 6 oylik hisobot.
///
/// `now` oyidan boshlab orqaga 6 oy. Eng yangi oy birinchi.
/// Har oy uchun shu oydagi kirimlar va chiqimlar yig'indisi.
/// Yozuvlari yo'q oyda ham qator bo'lsin (0 va 0).
/// Oy "2026-11" ko'rinishida. Yilni kesib o'tishga e'tibor bering
/// (fevraldan keyin oldingi yilning dekabri keladi).
///
/// Misol: now = 2026-11-17 bo'lsa, oylar:
///   2026-11, 2026-10, 2026-09, 2026-08, 2026-07, 2026-06
/// Misol: now = 2026-02-10 bo'lsa:
///   2026-02, 2026-01, 2025-12, 2025-11, 2025-10, 2025-09
List<MonthRow> monthlyReport(List<Tx> txs, DateTime now) {
  // TODO
  return [];
}
