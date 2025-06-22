import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Comboio.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<List<Comboio>> fetchComboiosForStation(String station) async {
    final snap = await _db
        .collection('Comboio')
        .where('linha de sintra', arrayContains: station) // requires 'estacoes' array in Firestore docs
        .get();

    print("encontrei ${snap.docs.length} documentos");

    return snap.docs.map((d) => Comboio.fromFirestore(d)).toList();
  }

}
