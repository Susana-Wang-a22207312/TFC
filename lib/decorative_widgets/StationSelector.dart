import 'package:flutter/material.dart';

class StationSelector extends StatelessWidget {
  final List<String> stations;
  final String selectedOrigin;
  final String selectedDestination;
  final ValueChanged<String> onOriginChanged;
  final ValueChanged<String> onDestinationChanged;

  const StationSelector({
    Key? key,
    required this.stations,
    required this.selectedOrigin,
    required this.selectedDestination,
    required this.onOriginChanged,
    required this.onDestinationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredDestinations = stations.where((s) => s != selectedOrigin).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecionar estação de origem:'),
        // dropdown or search query?
        DropdownButton<String>(
          key: Key('originField'),
          isExpanded: true,
          value: selectedOrigin.isNotEmpty ? selectedOrigin : null,
          hint: const Text('Estação de Origem'),
          onChanged: (value) {
            if (value != null) onOriginChanged(value);
          },
          items: stations
              .map((station) => DropdownMenuItem(value: station, child: Text(station)))
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text('Selecionar estação de destino:'),
        DropdownButton<String>(
          key: Key('destinationField'),
          isExpanded: true,
          value: selectedDestination.isNotEmpty ? selectedDestination : null,
          hint: const Text('Estação de Destino'),
          onChanged: (value) {
            if (value != null) onDestinationChanged(value);
          },
          items: filteredDestinations
              .map((station) => DropdownMenuItem(value: station, child: Text(station)))
              .toList(),
        ),
      ],
    );
  }
}
