import 'package:flutter/material.dart';
import '../decorative_widgets/TrainListWidget.dart';
import '../models/Comboio.dart';

import 'CarriageDetailScreen.dart';

class DetailScreen extends StatelessWidget {
  final List<Comboio> comboios;

  DetailScreen({required this.comboios});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes dos Comboios')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: comboios.length,
        itemBuilder: (context, index) {
          final comboio = comboios[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrainListWidget(comboio: comboio),  // One train per widget
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarriageDetailPage(comboio: comboio),
                        ),
                      );
                    },
                    icon: Icon(Icons.view_carousel),
                    label: Text('Ver detalhes'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
