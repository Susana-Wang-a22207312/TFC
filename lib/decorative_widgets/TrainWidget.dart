import 'package:flutter/material.dart';

class TrainWidget extends StatelessWidget {
  final String schedule;
  final Map<String, int> carriages;
  final String trainId;

  const TrainWidget({
    Key? key,
    required this.schedule,
    required this.carriages,
    required this.trainId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minCarriageEntry = carriages.entries.reduce(
          (curr, next) => next.value < curr.value ? next : curr,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final numCarriages = carriages.length;
        final carriageWidth = maxWidth / numCarriages;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 8),
                child: Text(
                  'Distribuição de Ocupação',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),

              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: carriages.entries.map((entry) {
                      final isRecommended = entry.key == minCarriageEntry.key;
                      final occupancy = entry.value;

                      return Container(
                        width: carriageWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isRecommended)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: const [
                                    Icon(Icons.star, color: Colors.amber, size: 18),
                                    Text(
                                      'Recomendado',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isRecommended ? Colors.amber : Colors.blue.shade200,
                                  width: isRecommended ? 3 : 1.5,
                                ),
                                boxShadow: isRecommended
                                    ? [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: occupancy / 100,
                                  widthFactor: 0.85,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getColor(occupancy),
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(16),
                                        top: occupancy == 100 ? Radius.circular(16) : Radius.zero,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: getColor(occupancy).withOpacity(0.7),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Carruagem ${entry.key}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '$occupancy%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: getColor(occupancy),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color getColor(int percent) {
    if (percent <= 50) return Colors.green.shade600;
    if (percent <= 70) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
