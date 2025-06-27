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

  List<Comboio> filterComboiosByTime(
      List<Comboio> comboios,
      DateTime? partidaPicked,
      DateTime? chegadaPicked,
      String origem,
      String destino,
      ) {

    int? partidaStartMin, partidaEndMin;
    if (partidaPicked != null) {
      partidaStartMin = partidaPicked.hour * 60 + partidaPicked.minute;
      partidaEndMin = partidaStartMin + 30;
    }
    int? chegadaStartMin, chegadaEndMin;
    if (chegadaPicked != null) {
      chegadaEndMin = chegadaPicked.hour * 60 + chegadaPicked.minute;
      chegadaStartMin = chegadaEndMin - 30;
    }

    return comboios.where((train) {
      final partidaTimes = train.temposChegada
          .where((s) => s.estacao == origem)
          .map((s) => s.tempo)
          .toList();
      final chegadaTimes = train.temposChegada
          .where((s) => s.estacao == destino)
          .map((s) => s.tempo)
          .toList();


      if (partidaTimes.isEmpty || chegadaTimes.isEmpty) return false;

      // Check partida window: if no partidaPicked, always true; else any time in window
      final partidaOK = partidaStartMin == null
          ? true
          : partidaTimes.any((t) => _isInWindow(t, partidaStartMin!, partidaEndMin!));

      // Check chegada window: if no chegadaPicked, always true; else any time in window
      final chegadaOK = chegadaEndMin == null
          ? true
          : chegadaTimes.any((t) => _isInWindow(t, chegadaStartMin!, chegadaEndMin!));

      return partidaOK && chegadaOK;
    }).toList();
  }

  int? _parseTimeToMinutes(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  bool _isInWindow(String timeStr, int startMin, int endMin) {
    final minutes = _parseTimeToMinutes(timeStr);
    if (minutes == null) return false;
    return minutes >= startMin && minutes <= endMin;
  }

}
