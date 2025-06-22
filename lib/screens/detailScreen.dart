import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Comboio.dart';
import 'CarriageDetailScreen.dart';

class DetailScreen extends StatelessWidget {
  final Comboio comboio;

  DetailScreen({required this.comboio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Comboio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Número: ${comboio.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Linha: ${comboio.linha}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Hora de partida: ${comboio.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Hora de chegada: ${comboio.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Origem: ${comboio.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Destino: ${comboio.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to carriage visualization
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarriageDetailPage(nomeEstacaoOrigem: '', nomeEstacaoDestino: '',),
                    ),
                  );
                },
                child: Text('Ver carruagens'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
