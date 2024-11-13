class Comboio {
  int id;
  String linha;
  String estacaoOrigem;
  String estacaoDestino;
  List<int> lotacao;

  Comboio(this.id,this.linha, this.estacaoOrigem,  this.estacaoDestino, this.lotacao);

  String estacaoDeOrigem()
  {
    return estacaoOrigem;
  }

  String estacaoDeDestino()
  {
    return estacaoDestino;
  }

  static List<Comboio> obterComboiosPorEstacao(String estacao) {
    return [
      Comboio(1, 'Sintra', estacao, 'Sintra',[20, 50, 80]),
      Comboio(2, 'Sintra',estacao,'Sintra',  [30, 45, 60]),
      Comboio(3,'Sintra', estacao,'Sintra',  [25, 55, 75]),
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
