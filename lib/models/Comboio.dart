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
    return temposChegada.last.toString();
  }

  String estacaoDeDestino()
  {
    return temposChegada.first.toString();
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
      'Lisboa -Rossio',
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
}

