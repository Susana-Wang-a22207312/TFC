import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Comboio.dart';
import 'RailDivider.dart';

class TrainListWidget extends StatelessWidget {
  final Comboio comboio;

  const TrainListWidget({required this.comboio, Key? key}) : super(key: key);

  String carruagemRecomendada(Map<String, int> lotacao) {
    if (lotacao.isEmpty) return 'Indisponível';
    String minCarriage = lotacao.keys.first;
    int minValue = lotacao[minCarriage]!;

    lotacao.forEach((carriage, occupancy) {
      if (occupancy < minValue) {
        minValue = occupancy;
        minCarriage = carriage;
      }
    });

    return 'Carruagem $minCarriage';
  }


  @override
  Widget build(BuildContext context) {
    final recommendedCarriage = carruagemRecomendada(comboio.lotacao);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Linha', style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 4),
            Text('${comboio.linha}', style: Theme.of(context).textTheme.titleMedium),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Origin info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Origem', style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: 2),
                    Text('${comboio.estacaoOrigem}', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 2),
                    Text('Partida: ${comboio.mostraTempo(comboio.estacaoOrigem)}'),
                  ],
                ),
                // RailDivider
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: RailDivider(),
                  ),
                ),
                // Destination info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Destino', style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: 2),
                    Text('${comboio.estacaoDestino}', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 2),
                    Text('Chegada: ${comboio.mostraTempo(comboio.estacaoDestino)}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.train, color: Colors.green.shade700),
                  SizedBox(width: 8),
                  Text(
                    'Carruagem Recomendada: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Text(
                    recommendedCarriage,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
