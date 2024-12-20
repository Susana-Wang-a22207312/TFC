import 'package:flutter/material.dart';
import '../models/Schedule.dart';

class horarioScreen extends StatelessWidget {
  final List<Schedule> schedule;
  final String selectedStation;

  const horarioScreen({
    Key? key,
    required this.schedule,
    required this.selectedStation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horários do Comboio"),
      ),
      body: ListView.builder(
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final stop = schedule[index];
          final isSelected = stop.estacao == selectedStation;

          return ListTile(
            leading: Icon(
              Icons.access_time,
              color: isSelected ? Colors.blue : null, // Ícone azul para a estação escolhida
            ),
            title: Text(
              stop.estacao,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // Texto em negrito
                color: isSelected ? Colors.blue : null, // Texto azul para destaque
              ),
            ),
            subtitle: Text("Horário: ${stop.tempo}"),
            tileColor: isSelected ? Colors.blue.shade50 : null, // Fundo diferente
          );
        },
      ),
    );
  }
}
