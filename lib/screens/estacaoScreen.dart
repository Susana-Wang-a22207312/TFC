import 'package:flutter/material.dart';
import '../decorative_widgets/RailDivider.dart';
import '../decorative_widgets/TrainWidget.dart';
import '../firebase_service.dart';
import '../models/Comboio.dart';
import '../models/Schedule.dart';
import '../screens/horarioScreen.dart';


class StationDetailPage extends StatefulWidget {
  final String nomeEstacaoOrigem;
  final String nomeEstacaoDestino;

  const StationDetailPage({
    Key? key,
    required this.nomeEstacaoOrigem,
    required this.nomeEstacaoDestino,
  }) : super(key: key);

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  late Future<List<Comboio>> _futureComboios;

  @override
  void initState() {
    super.initState();
    _futureComboios =
        FirebaseService().fetchComboiosForStation(widget.nomeEstacaoOrigem);
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(title: const Text("Próximos comboios:")),
        body: Column(
          children: [

            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                height: 80,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFdfe6e0)),
                child: Row(
                  children: [
                    Text("Origem: ${widget.nomeEstacaoOrigem}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: RailDivider(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("Destino: ${widget.nomeEstacaoDestino}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: FutureBuilder<List<Comboio>>(
                future: _futureComboios,
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text("Erro: ${snap.error}"));
                  }

                  final comboios = snap.data!;
                  if (comboios.isEmpty) {
                    return const Center(
                        child: Text("Nenhum comboio encontrado."));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 32),
                    itemCount: comboios.length,
                    separatorBuilder: (_, __) => Column(
                      children: const [
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: RailDivider(),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                    itemBuilder: (_, i) {
                      final c = comboios[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TrainWidget(
                          schedule: c.mostraTempo(widget.nomeEstacaoOrigem),
                          carriages: c.ocupacoes,
                          trainId: c.id,
                          onHorarioPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => horarioScreen(
                                  schedule: c.temposChegada,
                                  selectedStation: widget.nomeEstacaoOrigem,
                                ),
                              ),
                            );
                          },
                        ),
                      );

                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}






