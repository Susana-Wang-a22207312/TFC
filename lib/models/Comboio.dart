import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namer_app/models/Schedule.dart';

class Comboio {
  String id;
  String linha;
  String variante;
  String sentido;
  String estacaoOrigem;
  String estacaoDestino;
  List<String> estacoes;
  List<Schedule> temposChegada;
  Map<String, int> lotacao;
  int numCarriages;
  int occupancyPercent;

  Comboio({
    required this.id,
    required this.linha,
    required this.variante,
    required this.sentido,
    required this.estacaoOrigem,
    required this.estacaoDestino,
    required this.estacoes,
    required this.temposChegada,
    required this.lotacao,
    required this.numCarriages,
    required this.occupancyPercent,
  });

  String mostraTempo(String station) {
    if (temposChegada.isEmpty) {
      return "Horário indisponível";
    }
    for (var t in temposChegada) {
      if (t.estacao == station) {
        return t.tempo;
      }
    }
    return "Horário não disponível para $station";
  }

  factory Comboio.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final id = doc.id;
    final linha = data['linha'] as String? ?? '';
    final variante = data['variante'] as String? ?? '';
    final sentido = data['sentido'] as String? ?? '';
    final estacaoOrigem = data['estacaoOrigem'] as String? ?? '';
    final estacaoDestino = data['estacaoDestino'] as String? ?? '';
    final estacoes = (data['estacoes'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    final temposChegada = (data['temposChegada'] as List<dynamic>?)
        ?.map((e) => Schedule.fromMap(Map<String, dynamic>.from(e)))
        .toList() ??
        [];

    final lotacaoRaw = data['lotacao'] as Map<String, dynamic>? ?? {};
    final lotacao = lotacaoRaw.map((key, value) =>
        MapEntry(key, (value is int) ? value : int.tryParse(value.toString()) ?? 0));

    final numCarriages = data['numCarriages'] as int? ?? lotacao.length;

    final occupancyPercent = data['occupancyPercent'] as int? ?? 0;

    return Comboio(
      id: id,
      linha: linha,
      variante: variante,
      sentido: sentido,
      estacaoOrigem: estacaoOrigem,
      estacaoDestino: estacaoDestino,
      estacoes: estacoes,
      temposChegada: temposChegada,
      lotacao: lotacao,
      numCarriages: numCarriages,
      occupancyPercent: occupancyPercent,
    );
  }
}
