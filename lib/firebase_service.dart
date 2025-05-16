import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Comboio.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<List<Comboio>> fetchComboiosForStation(String station) async {
    final snap = await _db.collection('Comboio').get();
    print("encontrei ${snap.docs.length} documentos");

    final all = snap.docs.map((d) {
      final c = Comboio.fromFirestore(d);
      //print("  • Comboio ${c.id} stops at: ${c.temposChegada.map((s) => s.estacao).toList()}");
      return c;
    }).toList();

    // Correct filter over List<Schedule>:
    final filtered = all
        .where((c) => c.temposChegada.any((s) => s.estacao == station))
        .toList();

    //print("filtro para estacao '$station': ${filtered.length} matches");
    return filtered;
  }
}
