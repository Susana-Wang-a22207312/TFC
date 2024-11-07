import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Comboio.dart';
import '../screens/estacao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Comboios Suzy',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xADDFE0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String estacao = "";
  List<Comboio> comboiosEstacao = [];

  List<String> get obterEstacoesLinhaSintras =>
      Comboio.obterEstacoesLinhaSintra();

  void selectStation(String station) {
    estacao = station;
    comboiosEstacao = Comboio.obterComboiosPorEstacao(station);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(title: Text('Comboios Suzy')),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
          body: page,
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Seleciona uma estação: "),
          DropdownButton<String>(
            value: appState.estacao.isNotEmpty ? appState.estacao : null,
            hint: Text("Estação"),
            onChanged: (String? newValue) {
              if (newValue != null) {
                appState.selectStation(newValue);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationDetailPage(
                      nomeEstacao: newValue,
                      comboiosEstacao: appState.comboiosEstacao,
                    ),
                  ),
                );
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
        ],
      ),
    );
  }
}

