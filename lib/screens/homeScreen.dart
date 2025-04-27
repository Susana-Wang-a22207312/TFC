import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Comboio.dart';
import '../screens/estacaoScreen.dart';

class MyAppState extends ChangeNotifier {
  String estacaoOrigem = "";
  String estacaoDestino = "";
  List<Comboio> comboiosEstacao = [];

  List<String> get obterEstacoesLinhaSintras => Comboio.obterEstacoesLinhaSintra();

  void selectStation(String station) {
    estacaoOrigem = station;
    comboiosEstacao = Comboio.obterComboiosPorEstacao(station);
    notifyListeners();
  }

  void selectDestination(String station) {
    estacaoDestino = station;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // <- Agora aqui!

  Future<void> addData() async {
    try {
      await _firestore.collection('users').add({
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'age': 30,
      });
      print("Document Added!");
    } catch (e) {
      print('Failed to add document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(onAddData: addData); // Passar função para GeneratorPage
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Comboios')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: page,
    );
  }
}

class GeneratorPage extends StatelessWidget {
  final VoidCallback onAddData;

  GeneratorPage({required this.onAddData}); // Recebe a função do botão!

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Selecionar estação de origem: "),
          DropdownButton<String>(
            value: appState.estacaoOrigem.isNotEmpty ? appState.estacaoOrigem : null,
            hint: Text("Estação de Origem"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                appState.selectStation(newValue);
              }
            },
            items: appState.obterEstacoesLinhaSintras
                .map<DropdownMenuItem<String>>((String station) {
              return DropdownMenuItem<String>(
                value: station,
                child: Text(station),
              );
            }).toList(),
          ),
          Text("Selecionar estação de destino: "),
          DropdownButton<String>(
            value: appState.estacaoDestino.isNotEmpty ? appState.estacaoDestino : null,
            hint: Text("Estação de Destino"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                appState.selectDestination(newValue);
              }
            },
            items: appState.obterEstacoesLinhaSintras
                .map<DropdownMenuItem<String>>((String station) {
              return DropdownMenuItem<String>(
                value: station,
                child: Text(station),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (appState.estacaoOrigem.isNotEmpty && appState.estacaoDestino.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationDetailPage(
                      nomeEstacaoOrigem: appState.estacaoOrigem,
                      nomeEstacaoDestino: appState.estacaoDestino,
                      comboiosEstacao: appState.comboiosEstacao,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecione ambas as estações de origem e destino.")),
                );
              }
            },
            child: Text("Ver Comboios"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onAddData,
            child: Text("Adicionar utilizador ao Firebase"), // Botão que usa a função passada
          ),
        ],
      ),
    );
  }
}
