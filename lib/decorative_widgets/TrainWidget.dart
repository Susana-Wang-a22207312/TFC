import 'package:flutter/material.dart';
import 'BulletTrainHeadLeftClipper.dart';
import 'BulletTrainHeadRightClipper.dart';

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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            Positioned(
                              bottom: -20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  SizedBox(width: 4),
                                  Text(
                                    'Recomendado',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 20),
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
                    onPressed: onHorarioPressed, child: const Text("Horário")),
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
