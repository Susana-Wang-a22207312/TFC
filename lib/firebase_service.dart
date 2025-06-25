import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/Comboio.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<List<Comboio>> fetchComboiosWithStations(String origem, String destino) async {
    final snapshot = await _db.collection('Comboio').get();

    return snapshot.docs
        .map((doc) => Comboio.fromFirestore(doc))
        .where((comboio) {
      final estacoes = comboio.temposChegada.map((s) => s.estacao).toList();
      final origemIndex = estacoes.indexOf(origem);
      final destinoIndex = estacoes.indexOf(destino);
      return origemIndex >= 0 && destinoIndex >= 0 && origemIndex < destinoIndex;
    })
        .toList();
  }
  Future<List<String>> fetchAllStations() async {
    final snapshot = await _db.collection('Comboio').get();

    final stations = <String>{};
    for (var doc in snapshot.docs) {
      final comboio = Comboio.fromFirestore(doc);
      comboio.temposChegada.forEach((schedule) {
        stations.add(schedule.estacao);
      });
    }

    return stations.toList()..sort();
  }
}
