import 'package:flutter/material.dart';
import '../models/Comboio.dart';
import '../screens/horarioScreen.dart';

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

                int minOcupacao = comboio.lotacao.reduce((a, b) => a < b ? a : b);
                int carruagemRecomendada = comboio.lotacao.indexOf(minOcupacao) + 1;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      "Comboio ${comboio.id} | ${comboio.estacaoDeOrigem()} → ${comboio.estacaoDeDestino()}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Percentagem de ocupação:"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            comboio.lotacao.length,
                                (i) {
                              int ocupacao = comboio.lotacao[i];
                              bool isRecommended = (i + 1) == carruagemRecomendada;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    if (isRecommended)
                                      Icon(Icons.star, color: Colors.amber, size: 20),
                                    SizedBox(width: isRecommended ? 5 : 0),
                                    Text(
                                      "Carruagem ${i + 1}: $ocupacao%",
                                      style: TextStyle(
                                        color: getColor(ocupacao),
                                        fontSize: isRecommended ? 18 : 14,
                                        fontWeight: isRecommended ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => horarioScreen(
                              schedule: comboio.temposChegada,
                              selectedStation: nomeEstacaoOrigem,
                            ),
                          ),
                        );
                      },
                      child: Text("Horário"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(int ocupacao) {
    if (ocupacao <= 50) {
      return Colors.green;
    } else if (ocupacao <= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
