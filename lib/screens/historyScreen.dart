import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homeScreen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('Faça login para ver o histórico.'));
    }

    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Viagens')),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text('Sem viagens anteriores.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('${data['origem']} → ${data['destino']}'),
                subtitle: Text('De ${data['startTime']} às ${data['endTime']}'),
                trailing: Icon(Icons.repeat),
                onTap: () {
                  // Reuse: fill appState and pop back
                  final appState = context.read<MyAppState>();
                  appState.selectStation(data['origem']);
                  appState.selectDestination(data['destino']);

                  Navigator.pop(context); // go back to GeneratorPage
                },
              );
            },
          );
        },
      ),
    );
  }
}
