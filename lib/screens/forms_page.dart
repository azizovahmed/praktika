import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';

// To'liq ekranli formalar. Ular `Navigator.push` bilan ochiladi.

class DebtFormScreen extends StatefulWidget {
  const DebtFormScreen({super.key, this.edit});

  /// Tahrirlash rejimida: tahrirlanayotgan qarz. Yangi qarz uchun null.
  final Debt? edit;

  @override
  State<DebtFormScreen> createState() => _DebtFormScreenState();
}

class _DebtFormScreenState extends State<DebtFormScreen> {
  final name = TextEditingController();
  final amt = TextEditingController();
  final note = TextEditingController();
  bool lent = true;
  String? due;
  String? err;

  @override
  void initState() {
    super.initState();
    final e = widget.edit;
    if (e != null) {
      name.text = e.name;
      amt.text = e.amount.round().toString();
      note.text = e.note;
      lent = e.lent;
      due = e.due;
    }
  }

  @override
  void dispose() {
    name.dispose();
    amt.dispose();
    note.dispose();
    super.dispose();
  }

  void save() {
    // TODO (10-vazifa: yangi qarz, 14-vazifa: tahrirlash, TASKS.md):
    //  - ism va summani tekshiring (err ga xabar yozing)
    //  - widget.edit == null bo'lsa yangi Debt yarating va app.debts ga qo'shing
    //  - widget.edit bor bo'lsa, shu qarzning maydonlarini o'zgartiring
    //  - app.changed() ni chaqiring, ro'yxat yangilansin
    Navigator.pop(context); // oldingi oynaga qaytish
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.edit == null ? 'Yangi qarz' : 'Qarzni tahrirlash')),
    body: ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom + 300),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Men qarz berdim')),
            ButtonSegment(value: false, label: Text('Men qarz oldim')),
          ],
          selected: {lent},
          onSelectionChanged: (s) => setState(() => lent = s.first),
        ),
        const SizedBox(height: 12),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Ism', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(
            controller: amt,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Summa (so’m)', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.event),
          label: Text(due == null ? 'Qaytarish muddati (ixtiyoriy)' : 'Muddat: $due'),
          onPressed: () async {
            final d = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100));
            if (d != null) setState(() => due = d.toIso8601String().substring(0, 10));
          },
        ),
        const SizedBox(height: 10),
        TextField(controller: note, decoration: const InputDecoration(labelText: 'Izoh', border: OutlineInputBorder())),
        if (err != null)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(err!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        const SizedBox(height: 12),
        FilledButton(onPressed: save, child: const Text('Saqlash')),
      ],
    ),
  );
}

class TxFormScreen extends StatefulWidget {
  const TxFormScreen({super.key});

  @override
  State<TxFormScreen> createState() => _TxFormScreenState();
}

class _TxFormScreenState extends State<TxFormScreen> {
  final amt = TextEditingController();
  final note = TextEditingController();
  bool income = true;
  String date = today();
  String? err;

  @override
  void dispose() {
    amt.dispose();
    note.dispose();
    super.dispose();
  }

  void save() {
    // TODO (11-vazifa, TASKS.md):
    //  - summani tekshiring (err ga xabar yozing)
    //  - yangi Tx yarating, app.txs ga qo'shing, app.changed() ni chaqiring
    Navigator.pop(context); // oldingi oynaga qaytish
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Yangi yozuv')),
    body: ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom + 300),
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Kirim')),
            ButtonSegment(value: false, label: Text('Chiqim')),
          ],
          selected: {income},
          onSelectionChanged: (s) => setState(() => income = s.first),
        ),
        const SizedBox(height: 12),
        TextField(
            controller: amt,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Summa (so’m)', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.event),
          label: Text('Sana: $date'),
          onPressed: () async {
            final d = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100));
            if (d != null) setState(() => date = d.toIso8601String().substring(0, 10));
          },
        ),
        const SizedBox(height: 10),
        TextField(controller: note, decoration: const InputDecoration(labelText: 'Izoh', border: OutlineInputBorder())),
        if (err != null)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(err!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        const SizedBox(height: 12),
        FilledButton(onPressed: save, child: const Text('Saqlash')),
      ],
    ),
  );
}

