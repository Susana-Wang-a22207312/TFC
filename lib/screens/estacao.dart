import 'package:flutter/material.dart';
import '../models/Comboio.dart';

class StationDetailPage extends StatelessWidget {
  final String nomeEstacaoOrigem;
  final String nomeEstacaoDestino;
  final List<Comboio> comboiosEstacao;

  const StationDetailPage({
    Key? key,
    required this.nomeEstacaoOrigem,
    required this.nomeEstacaoDestino,
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
            child: Column(
              children: [
                Text(
                  "Origem: $nomeEstacaoOrigem",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Destino: $nomeEstacaoDestino",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comboiosEstacao.length,
              itemBuilder: (context, index) {
                var comboio = comboiosEstacao[index];
                String tempo = comboio.mostraTempo(nomeEstacaoOrigem);
                return ListTile(
                  title: Text("Comboio ${comboio.id} | ${tempo}"),
                  subtitle: Text(
                    "Percentagem de ocupação:\n"
                        "Carruagem 1: ${comboio.lotacao[0]}%\n"
                        "Carruagem 2: ${comboio.lotacao[1]}%\n"
                        "Carruagem 3: ${comboio.lotacao[2]}%",
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
