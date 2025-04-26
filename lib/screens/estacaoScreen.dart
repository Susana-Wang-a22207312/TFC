import 'package:flutter/material.dart';
import '../models/Comboio.dart';
import '../screens/horarioScreen.dart';
import 'dart:math';

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
      appBar: AppBar(title: const Text("Próximos comboios:")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Origem: $nomeEstacaoOrigem",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Destino: $nomeEstacaoDestino",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: comboiosEstacao.length,
              separatorBuilder: (context, index) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                var comboio = comboiosEstacao[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TrainWidget(
                        schedule: comboio.mostraTempo(nomeEstacaoOrigem),
                        carriages: comboio.lotacao,
                        trainId: comboio.id,
                        onHorarioPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => horarioScreen(
                                schedule: comboio.temposChegada,
                                selectedStation: nomeEstacaoOrigem,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // space for star
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: RailDivider(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TrainWidget extends StatelessWidget {
  final String schedule;
  final List<int> carriages;
  final int trainId;
  final VoidCallback onHorarioPressed;

  const TrainWidget({
    Key? key,
    required this.schedule,
    required this.carriages,
    required this.trainId,
    required this.onHorarioPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int minIndex = 0;
    for (int i = 1; i < carriages.length; i++) {
      if (carriages[i] < carriages[minIndex]) minIndex = i;
    }

    return SizedBox(
      width: screenWidth * 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Train ID above
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              "Comboio $trainId",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Train row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Head with trainId
              SizedBox(
                width: 80,
                height: 100,
                child: ClipPath(
                  clipper: BulletTrainHeadLeftClipper(),
                  child: Container(
                    color: Colors.blue.shade700,
                    child: Center(
                      child: Text(
                        trainId.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Carriages
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: carriages.asMap().entries.map((entry) {
                    int idx = entry.key;
                    int percent = entry.value;
                    bool isBest = idx == minIndex;
                    return Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // carriage container
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: isBest
                                      ? Colors.amber
                                      : Colors.blue.shade200,
                                  width: isBest ? 2 : 1),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor: percent / 100,
                                    widthFactor: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: getColor(percent),
                                        borderRadius: percent == 100
                                            ? BorderRadius.circular(16)
                                            : const BorderRadius.vertical(
                                            bottom: Radius.circular(16)),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "$percent%",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // carriage number
                          Positioned(
                            top: -20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                "Carruagem ${idx + 1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),

                            ),
                          ),

                          if (isBest)
                            const Positioned(
                              bottom: -20,
                              left: 0,
                              right: 0,
                              child: Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 20),
              // Tail with schedule
              SizedBox(
                width: 80,
                height: 100,
                child: ClipPath(
                  clipper: BulletTrainHeadRightClipper(),
                  child: Container(
                    color: Colors.blue.shade300,
                    child: Center(
                      child: Text(
                        schedule,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                height: 100,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: onHorarioPressed,
                    child: const Text("Horário")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getColor(int percent) {
    if (percent <= 50) return Colors.green;
    if (percent <= 70) return Colors.orange;
    return Colors.red;
  }
}

// Clippers
class BulletTrainHeadLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double noseW = size.width * 0.4;
    var noseRect = Rect.fromLTWH(0, 0, noseW * 2, size.height);
    path.moveTo(noseW, 0);
    path.arcTo(noseRect, -pi / 2, -pi, false);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}

class BulletTrainHeadRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double noseW = size.width * 0.4;
    var noseRect = Rect.fromLTWH(size.width - noseW * 2, 0, noseW * 2, size.height);
    path.moveTo(size.width - noseW, 0);
    path.arcTo(noseRect, -pi / 2, pi, false);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}

// Rail Divider
class RailDivider extends StatelessWidget {
  const RailDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: CustomPaint(
        painter: _RailPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _RailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint railPaint = Paint()..color = Colors.grey.shade600..strokeWidth = 4;
    Paint tiePaint = Paint()..color = Colors.grey.shade400..strokeWidth = 2;
    double y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), railPaint);
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), tiePaint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}