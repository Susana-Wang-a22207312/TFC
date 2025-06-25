import 'package:flutter/material.dart';
import '../decorative_widgets/RailDivider.dart';
import '../models/Comboio.dart';

class TrainListWidget extends StatelessWidget {
  final Comboio comboio;
  final String? selectedOrigem;
  final String? partidaHora;
  final String? selectedDestino;
  final String? chegadaHora;
  final VoidCallback? onTapDetails;

  const TrainListWidget({
    Key? key,
    required this.comboio,
    this.selectedOrigem,
    this.partidaHora,
    this.selectedDestino,
    this.chegadaHora,
    this.onTapDetails,
  }) : super(key: key);

  String _recommendedCarriage(List<int> lotacao) {
    if (lotacao.isEmpty) return '—';
    int minIndex = 0;
    for (int i = 1; i < lotacao.length; i++) {
      if (lotacao[i] < lotacao[minIndex]) minIndex = i;
    }
    return '${minIndex + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recCarruagem = _recommendedCarriage(comboio.lotacao.values.toList());

    return InkWell(
      onTap: onTapDetails,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Linha and a detalhes icon
            Row(
              children: [
                Icon(Icons.train, color: Colors.green.shade700),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comboio.linha,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                if (onTapDetails != null)
                  Icon(Icons.chevron_right, color: Colors.grey.shade600),
              ],
            ),
            const SizedBox(height: 12),

            // If selected stations provided, show them with times
            if (selectedOrigem != null && selectedDestino != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Origem + time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Origem', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '$selectedOrigem',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (partidaHora != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          partidaHora!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),

                  // Rail divider
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RailDivider(),
                    ),
                  ),

                  // Destino + time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Destino', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '$selectedDestino',
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (chegadaHora != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          chegadaHora!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ] else
              // If no selected stations passed, show default orig/dest
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Origem', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(comboio.estacaoOrigem,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RailDivider(),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Destino', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(comboio.estacaoDestino,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Recommended carriage info
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade600, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Carruagem recomendada: $recCarruagem',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
