import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Comboio.dart';
import '../screens/estacaoScreen.dart';
import '../services/auth_service.dart';
import 'loginScreen.dart';

class MyAppState extends ChangeNotifier {
  String estacaoOrigem = "";
  String estacaoDestino = "";

  List<String> get obterEstacoesLinhaSintras => Comboio.obterEstacoesLinhaSintra();

  void selectStation(String station) {
    estacaoOrigem = station;
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
  final _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    setState(() {
      _isLoggedIn = false;
    });
  }

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

    return Scaffold(
      appBar: AppBar(title: Text('Comboios')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            _isLoggedIn
                ? ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await _logout();
                Navigator.pop(context);
              },
            )
                : ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      onSignedIn: () {
                        setState(() {
                          _isLoggedIn = true;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: page,
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
              if (appState.estacaoOrigem.isEmpty || appState.estacaoDestino.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecione ambas as estações de origem e destino.")),
                );
                return;
              }
              if (appState.estacaoOrigem == appState.estacaoDestino) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Estação de origem e destino não podem ser iguais.")),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StationDetailPage(
                    nomeEstacaoOrigem: appState.estacaoOrigem,
                    nomeEstacaoDestino: appState.estacaoDestino,
                  ),
                ),
              );
            },
            child: Text("Ver Comboios"),
          ),
        ],
      ),
    );
  }
}
