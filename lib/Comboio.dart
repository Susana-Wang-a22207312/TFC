import 'dart:ffi';

class Comboio {
  int id;
  String estacaoOrigem;
  String estacaoDestino;
  List<int> lotacao;

  Comboio(this.id, this.estacaoOrigem, this.estacaoDestino, this.lotacao);

  List<String> obterEstacoesLinhaSintra() {
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
}
