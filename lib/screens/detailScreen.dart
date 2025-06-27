import 'package:flutter/material.dart';
import '../decorative_widgets/TrainListWidget.dart';
import '../models/Comboio.dart';
import 'CarriageDetailScreen.dart';

class DetailScreen extends StatelessWidget {
  final List<Comboio> comboios;
  final DateTime? partidaPicked;
  final DateTime? chegadaPicked;
  final String selectedOrigem;
  final String selectedDestino;

  DetailScreen({
    required this.comboios,
    this.partidaPicked,
    this.chegadaPicked,
    required this.selectedOrigem,
    required this.selectedDestino,
  });

  int? _parseTimeToMinutes(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  int _absDiff(int trainMin, int pickMin) {
    return (trainMin - pickMin).abs();
  }

  String? _getTimeAtStation(Comboio comboio, String station) {
    for (var s in comboio.temposChegada) {
      if (s.estacao == station) return s.tempo;
    }
    return null;
  }

  int? _getMinutesAtStation(Comboio comboio, String station) {
    final tempo = _getTimeAtStation(comboio, station);
    return tempo != null ? _parseTimeToMinutes(tempo) : null;
  }

  @override
  Widget build(BuildContext context) {

    // ordenar comboios
    final sortedComboios = List<Comboio>.from(comboios);
    sortedComboios.sort((a, b) {
      int? aOrigMin = _getMinutesAtStation(a, selectedOrigem);
      int? bOrigMin = _getMinutesAtStation(b, selectedOrigem);
      int? aDestMin = _getMinutesAtStation(a, selectedDestino);
      int? bDestMin = _getMinutesAtStation(b, selectedDestino);

      int metricA = 0, metricB = 0;
      if (partidaPicked != null) {
        final pickMin = partidaPicked!.hour * 60 + partidaPicked!.minute;
        metricA += aOrigMin != null ? _absDiff(aOrigMin, pickMin) : 1440;
        metricB += bOrigMin != null ? _absDiff(bOrigMin, pickMin) : 1440;
      }
      if (chegadaPicked != null) {
        final pickMin = chegadaPicked!.hour * 60 + chegadaPicked!.minute;
        metricA += aDestMin != null ? _absDiff(aDestMin, pickMin) : 1440;
        metricB += bDestMin != null ? _absDiff(bDestMin, pickMin) : 1440;
      }
      return metricA.compareTo(metricB);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Comboios encontrados', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedComboios.length,
        itemBuilder: (context, index) {
          final comboio = sortedComboios[index];

          final partidaHora = _getTimeAtStation(comboio, selectedOrigem) ?? '—';
          final chegadaHora = _getTimeAtStation(comboio, selectedDestino) ?? '—';

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TrainListWidget(
              comboio: comboio,
              selectedOrigem: selectedOrigem,
              partidaHora: partidaHora,
              selectedDestino: selectedDestino,
              chegadaHora: chegadaHora,
              onTapDetails: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarriageDetailPage(
                      comboio: comboio,
                      selectedOrigem: selectedOrigem,
                      selectedDestino: selectedDestino,
                      partidaHora: partidaHora,
                      chegadaHora: chegadaHora,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
