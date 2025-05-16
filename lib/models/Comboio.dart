import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namer_app/models/Schedule.dart';

class Comboio {
  int id;
  String linha;
  String estacaoOrigem;
  String estacaoDestino;
  List<Schedule> temposChegada;
  List<int> lotacao;

  Comboio(this.id, this.linha, this.estacaoOrigem, this.estacaoDestino,
      this.temposChegada, this.lotacao);

  String estacaoDeOrigem()
  {
    return obterEstacoesLinhaSintra().first.toString();
  }

  String estacaoDeDestino()
  {
    return obterEstacoesLinhaSintra().last.toString();
  }

  String mostraTempo(String station) {
    for (var t in temposChegada) {
      if (t.estacao == station) {
        return t.tempo;
      }
    }
    return "Horário não disponível para $station";
  }


   static List<Schedule> obterEstacoesComTempo()
  {
    return [
      Schedule('Lisboa - Rossio', '10:00'),
      Schedule('Lisboa - Entrecampos', '10:05'),
      Schedule('Lisboa - Sete Rios', '10:10'),
      Schedule('Praça de Espanha', '10:15'),
      Schedule('Campo de Ourique', '10:20'),
      Schedule('Alfornelos', '10:25'),
      Schedule('Odivelas', '10:30'),
      Schedule('Póvoa de Santo Adrião', '10:35'),
      Schedule('Rio de Mouro', '10:40'),
      Schedule('Sintra', '10:45'),
    ];
  }


  
  static List<Comboio> obterComboiosPorEstacao(String estacao) {
    return [
      Comboio(1, 'Sintra', estacao, 'Sintra', obterEstacoesComTempo(),[20, 50, 80]),
      Comboio(2, 'Sintra',estacao,'Sintra', obterEstacoesComTempo(),[30, 45, 60]),
      Comboio(3,'Sintra', estacao,'Sintra', obterEstacoesComTempo() ,[25, 55, 75]),
    ];
  }

  static List<String> obterEstacoesLinhaSintra() {
    return [
      'Lisboa - Rossio',
      'Lisboa - Entrecampos',
      'Lisboa - Sete Rios',
      'Praça de Espanha',
      'Campo de Ourique',
      'Alfornelos',
      'Odivelas',
      'Póvoa de Santo Adrião',
      'Rio de Mouro',
      'Sintra',
    ];
  }

  List<int> get ocupacoes => lotacao;

  factory Comboio.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    //print("raw Comboio data (docID=${doc.id}): $data");

    final int id = int.tryParse(doc.id) ?? (data['id'] as int? ?? 0);

    final String linha          = data['linha']          as String? ?? '';
    final String estacaoOrigem  = data['estacaoOrigem']  as String? ?? '';
    final String estacaoDestino = data['estacaoDestino'] as String? ?? '';

    List<int> ocupacoes = [];
    if (data['Ocupacoes'] is List) {
      ocupacoes = List<int>.from((data['Ocupacoes'] as List).map((e) {
        if (e is num) return e.toInt();
        if (e is String) return int.tryParse(e) ?? 0;
        return 0;
      }));
    } else if (data['lotacao'] is num) {
      ocupacoes = [(data['lotacao'] as num).toInt()];
    }

    const possibleKeys = ['linha de sintra', 'linha sintra'];
    Map<String, dynamic>? rawMap;
    for (final key in possibleKeys) {
      final candidate = data[key];
      if (candidate is Map<String, dynamic>) {
        rawMap = candidate;
        break;
      }
    }
    rawMap ??= <String, dynamic>{};

    final List<Schedule> temposChegada = rawMap.entries
        .map((e) => Schedule(e.key, e.value as String))
        .toList();

    return Comboio(
      id,
      linha,
      estacaoOrigem,
      estacaoDestino,
      temposChegada,
      ocupacoes,
    );
  }



}

