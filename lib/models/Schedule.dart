class Schedule {
  String estacao;
  String tempo;

  Schedule(this.estacao, this.tempo);

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      map['estacao'] ?? '',
      map['tempo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'estacao': estacao,
      'tempo': tempo,
    };
  }

  @override
  String toString() {
    return "$estacao, $tempo";
  }
}
