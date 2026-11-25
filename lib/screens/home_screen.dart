import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:praktika/screens/forms_page.dart';

import '../data.dart';
import '../logic.dart';
import '../models.dart';
import 'auth_screens.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  String query = '';

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (x) => AlertDialog(
        title: const Text('Profildan chiqasizmi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(x, false), child: const Text('Yo’q')),
          FilledButton(onPressed: () => Navigator.pop(x, true), child: const Text('Ha, chiqish')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Qarz daftari'),
            actions: [
              IconButton(
                  tooltip: 'Chiqish',
                  icon: const Icon(Icons.logout),
                  onPressed: () => _logout(context)),
            ],
          ),
          body: Column(children: [
            _summary(context),
            Expanded(child: [_debtsTab(context), _txTab(context), _reportTab(context)][tab]),
          ]),
          floatingActionButton: tab == 2
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => tab == 0 ? const DebtFormScreen() : const TxFormScreen())),
                  icon: const Icon(Icons.add),
                  label: Text(tab == 0 ? 'Qarz qo’shish' : 'Yozuv qo’shish')),
          bottomNavigationBar: NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.people_outline), label: 'Qarzlar'),
              NavigationDestination(icon: Icon(Icons.swap_vert), label: 'Kirim-chiqim'),
              NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Hisobot'),
            ],
          ),
        ),
      );

  // ---------- tepadagi umumiy ko'rsatkichlar ----------
  Widget _summary(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final net = netPosition(app.debts, app.txs);
    Widget stat(String label, double v) => Expanded(
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                  Text(formatMoney(v), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ]))));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Sof holat', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
        Text(formatMoney(net),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: net < 0 ? cs.error : null)),
        Row(children: [
          stat('Kassa', cashBalance(app.txs)),
          stat('Menga qarzdor', totalLent(app.debts)),
          stat('Men qarzdorman', totalBorrowed(app.debts)),
        ]),
      ]),
    );
  }

  // ---------- Qarzlar ----------
  Widget _debtsTab(BuildContext context) {
    final list = searchDebts(app.debts, query);
    List<Widget> section(String title, List<Debt> items, String empty) => [
          Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
          if (items.isEmpty)
            Padding(padding: const EdgeInsets.all(4), child: Text(empty))
          else
            ...items.map((d) => _debtCard(context, d)),
        ];
    return ListView(padding: const EdgeInsets.fromLTRB(12, 0, 12, 90), children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
              hintText: 'Ism bo’yicha qidirish',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true),
        ),
      ),
      ...section('Menga qarzdorlar', list.where((d) => d.lent).toList(), 'Hozircha yo’q.'),
      ...section('Men qarzdorman', list.where((d) => !d.lent).toList(), 'Sizning qarzingiz yo’q.'),
    ]);
  }

  Widget _debtCard(BuildContext context, Debt d) {
    final cs = Theme.of(context).colorScheme;
    final rem = remaining(d);
    final over = isOverdue(d, today());
    final meta = [d.due != null ? 'muddat ${d.due}' : d.date, if (d.note.isNotEmpty) d.note].join(' · ');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(over ? 'Muddati o’tgan · $meta' : meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: over ? cs.error : cs.onSurfaceVariant, fontSize: 13)),
        trailing: Text(rem > 0 ? formatMoney(rem) : 'To’langan',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Jami ${formatMoney(d.amount)}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13))),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: d.amount > 0 ? ((d.amount - rem) / d.amount).clamp(0.0, 1.0) : 0),
          Row(children: [
            if (rem > 0)
              TextButton(onPressed: () => _payDialog(context, d), child: const Text('To’lov qo’shish')),
            TextButton(onPressed: () => _histDialog(context, d), child: Text('Tarix (${d.pays.length})')),
            const Spacer(),
            IconButton(
                tooltip: 'Tahrirlash',
                icon: const Icon(Icons.edit_outlined),
                // Tahrirlash oynasi shu qarz bilan to'ldirilib ochiladi.
                // Saqlashni 14-vazifada yozasiz (forms.dart).
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true, builder: (_) => DebtFormScreen(edit: d)))),
            IconButton(
                tooltip: 'O’chirish',
                icon: const Icon(Icons.delete_outline),
                // TODO (12-vazifa, TASKS.md): tasdiq so'rang, so'ng qarzni o'chiring
                onPressed: () {}),
          ]),
        ],
      ),
    );
  }

  Future<void> _payDialog(BuildContext context, Debt d) {
    final ctl = TextEditingController();
    String? err;
    return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text('To’lov: ${d.name}'),
          content: TextField(
              controller: ctl,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Summa', errorText: err)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Bekor')),
            FilledButton(
                onPressed: () {
                  final v = double.tryParse(ctl.text.replaceAll(' ', '')) ?? 0;
                  final e = addPayment(d, v, today()); // 8-vazifa shu funksiyani yozadi
                  if (e != null) {
                    set(() => err = e);
                    return;
                  }
                  app.changed();
                  Navigator.pop(ctx);
                },
                child: const Text('Saqlash')),
          ],
        ),
      ),
    );
  }

  Future<void> _histDialog(BuildContext context, Debt d) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Tarix: ${d.name}'),
          content: d.pays.isEmpty
              ? const Text('Hali to’lov yo’q.')
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  for (final p in d.pays.reversed)
                    ListTile(dense: true, title: Text('${p.date} · ${formatMoney(p.amount)}')),
                ]),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Yopish'))],
        ),
      );

  // ---------- Kirim-chiqim ----------
  Widget _txTab(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final list = [...app.txs]..sort((a, b) => b.date.compareTo(a.date));
    if (list.isEmpty) return const Center(child: Text('Hali yozuv yo’q.'));
    return ListView(padding: const EdgeInsets.fromLTRB(12, 8, 12, 90), children: [
      for (final t in list)
        Card(
          child: ListTile(
            title: Text(t.income ? 'Kirim' : 'Chiqim'),
            subtitle: Text([t.date, if (t.note.isNotEmpty) t.note].join(' · ')),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('${t.income ? '+' : '−'}${formatMoney(t.amount)}',
                  style: TextStyle(fontWeight: FontWeight.w600, color: t.income ? Colors.green : cs.error)),
              IconButton(
                  icon: const Icon(Icons.delete_outline),
                  // TODO (13-vazifa, TASKS.md): yozuvni o'chiring
                  onPressed: () {}),
            ]),
          ),
        ),
    ]);
  }

  // ---------- Hisobot ----------
  Widget _reportTab(BuildContext context) {
    Widget line(String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(a), Text(b, style: const TextStyle(fontWeight: FontWeight.w600))]));
    final rows = monthlyReport(app.txs, DateTime.now()); // 9-vazifa shu funksiyani yozadi
    return ListView(padding: const EdgeInsets.all(12), children: [
      Card(
          child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                line('Kassa balansi', formatMoney(cashBalance(app.txs))),
                line('Menga qarzdorlar qoldig’i', formatMoney(totalLent(app.debts))),
                line('Mening qarzlarim qoldig’i', formatMoney(totalBorrowed(app.debts))),
                line('Sof holat', formatMoney(netPosition(app.debts, app.txs))),
              ]))),
      const Padding(
          padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
          child: Text('Oxirgi 6 oy', style: TextStyle(fontWeight: FontWeight.w600))),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(14),
              child: rows.isEmpty
                  ? const Text('Hisobot bo’sh. monthlyReport funksiyasi hali yozilmagan (9-vazifa).')
                  : Column(children: [
                      for (final r in rows)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(children: [
                              SizedBox(width: 70, child: Text(r.month)),
                              Expanded(child: Text('+${formatMoney(r.income)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12))),
                              Expanded(child: Text('−${formatMoney(r.expense)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12))),
                              Expanded(child: Text(formatMoney(r.diff), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                            ])),
                    ]))),
    ]);
  }
}
