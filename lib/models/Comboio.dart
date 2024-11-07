class Comboio {
  int id;
  String estacaoOrigem;
  String estacaoDestino;
  List<int> lotacao;

  Comboio(this.id, this.estacaoOrigem, this.estacaoDestino, this.lotacao);

  static List<Comboio> obterComboiosPorEstacao(String estacao) {
    return [
      Comboio(1,  estacao, 'Sintra',[20, 50, 80]),
      Comboio(2, estacao,'Sintra',  [30, 45, 60]),
      Comboio(3, estacao,'Sintra',  [25, 55, 75]),
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
