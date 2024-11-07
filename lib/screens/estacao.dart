import 'package:flutter/material.dart';
import '../models/Comboio.dart';

class StationDetailPage extends StatelessWidget {
  final String nomeEstacao;
  final List<Comboio> comboiosEstacao;

  const StationDetailPage({
    Key? key,
    required this.nomeEstacao,
    required this.comboiosEstacao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Próximos comboios:")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Estação: $nomeEstacao',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comboiosEstacao.length,
              itemBuilder: (context, index) {
                var comboio = comboiosEstacao[index];
                return ListTile(
                  title: Text("Comboio ${comboio.id} | Destino: ${comboio.estacaoDestino}"),
                  subtitle: Text(
                    "Percentagem de ocupação: \nCarruagem 1: ${comboio.lotacao[0]}% \nCarruagem 2: ${comboio.lotacao[1]}% \nCarruagem 3: ${comboio.lotacao[2]}%",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
