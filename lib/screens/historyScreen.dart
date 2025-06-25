import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/homeScreen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Always return a Scaffold so AppBar/back button appears
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Viagens')),
      body: user == null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Faça login para ver o histórico.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      )
          : _buildHistoryList(context, user),
    );
  }

  Widget _buildHistoryList(BuildContext context, User user) {
    final historyRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: historyRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Sem viagens anteriores.'));
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            // Parse times (Timestamp or ISO string)
            DateTime? startDate;
            DateTime? endDate;
            final startRaw = data['startTime'];
            final endRaw = data['endTime'];
            if (startRaw is Timestamp) {
              startDate = startRaw.toDate();
            } else if (startRaw is String) {
              startDate = DateTime.tryParse(startRaw);
            }
            if (endRaw is Timestamp) {
              endDate = endRaw.toDate();
            } else if (endRaw is String) {
              endDate = DateTime.tryParse(endRaw);
            }

            final formattedStart = startDate != null
                ? DateFormat("dd-MM-yyyy 'a partir de' HH:mm").format(startDate)
                : '';
            final formattedEnd = endDate != null
                ? DateFormat("'até' dd-MM-yyyy  HH:mm").format(endDate)
                : '';

            return ListTile(
              title: Text('${data['origem']} → ${data['destino']}'),
              subtitle: Text('De $formattedStart $formattedEnd'),
              trailing: Icon(Icons.repeat),
              onTap: () {
                final appState = context.read<MyAppState>();
                appState.selectOrigin(data['origem']);
                appState.selectDestination(data['destino']);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
