import 'package:flutter/material.dart';
import '../decorative_widgets/RailDivider.dart';
import '../decorative_widgets/TrainWidget.dart';
import '../models/Comboio.dart';
import '../screens/horarioScreen.dart';

class CarriageDetailPage extends StatelessWidget {
  final Comboio comboio;
  final String selectedOrigem;
  final String selectedDestino;
  final String partidaHora;
  final String chegadaHora;

  const CarriageDetailPage({
    Key? key,
    required this.comboio,
    required this.selectedOrigem,
    required this.selectedDestino,
    required this.partidaHora,
    required this.chegadaHora,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedule = comboio.mostraTempo(selectedOrigem);
    final avgOccupancy = comboio.occupancyPercent;

    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Comboio", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Green card: linha + origem/linha + botão horário
          Card(
            color: Colors.green.shade100,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        comboio.linha,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Origem", style: Theme.of(context).textTheme.bodySmall),
                              Text(comboio.estacaoOrigem,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: RailDivider(),
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Destino", style: Theme.of(context).textTheme.bodySmall),
                              Text(comboio.estacaoDestino,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => horarioScreen(
                              schedule: comboio.temposChegada,
                              selectedStation: selectedOrigem,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.schedule, size: 18),
                      label: Text('Horário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Focused route: selectedOrigem → selectedDestino with times
          // Focused route: selectedOrigem → selectedDestino with times
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Trajeto selecionado",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 12), // reduced from 16
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedOrigem,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              partidaHora,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, color: Colors.grey.shade600),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              selectedDestino,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              chegadaHora,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Train layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TrainWidget(
              schedule: schedule,
              carriages: comboio.lotacao,
              trainId: comboio.id,
            ),
          ),
          SizedBox(height: 20),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt, color: getColor(avgOccupancy)),
                SizedBox(width: 8),
                Text(
                  'Ocupação média: $avgOccupancy%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: getColor(avgOccupancy),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color getColor(int percent) {
  if (percent <= 50) return Colors.green.shade600;
  if (percent <= 70) return Colors.orange.shade700;
  return Colors.red.shade700;
}
