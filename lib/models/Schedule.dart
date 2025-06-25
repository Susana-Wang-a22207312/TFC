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

  int get hour {
    try {
      return int.parse(tempo.split(':')[0]);
    } catch (_) {
      return 0;
    }
  }

  int get minute {
    try {
      return int.parse(tempo.split(':')[1]);
    } catch (_) {
      return 0;
    }
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
