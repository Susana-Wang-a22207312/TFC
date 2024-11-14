class Schedule {
  String estacao;
  String tempo;

  Schedule(this.estacao, this.tempo);

  @override
  String toString() {
    return "$estacao, $tempo";
  }
}