import 'package:flutter/material.dart';
import '../decorative_widgets/RailDivider.dart';
import '../decorative_widgets/TrainWidget.dart';
import '../firebase_service.dart';
import '../models/Comboio.dart';
import '../models/Schedule.dart';
import '../screens/horarioScreen.dart';


class CarriageDetailPage extends StatelessWidget {
  final Comboio comboio;

  const CarriageDetailPage({Key? key, required this.comboio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedule = comboio.mostraTempo(comboio.estacaoOrigem);

    return Scaffold(
      appBar: AppBar(title: Text("Comboio ${comboio.id}")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Origem: ${comboio.estacaoOrigem}", style: TextStyle(fontSize: 18)),
          Text("Destino: ${comboio.estacaoDestino}", style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          TrainWidget(
            schedule: schedule,
            carriages: comboio.lotacao,
            trainId: comboio.id,
            onHorarioPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => horarioScreen(
                    schedule: comboio.temposChegada,
                    selectedStation: comboio.estacaoOrigem,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
