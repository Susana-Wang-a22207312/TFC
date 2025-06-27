import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../decorative_widgets/StationSelector.dart';
import '../decorative_widgets/TimePickers.dart';
import '../firebase_service.dart';
import '../services/auth_service.dart';
import 'detailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Comboio.dart';
import 'historyScreen.dart';
import 'loginScreen.dart';

class MyAppState extends ChangeNotifier {
  String estacaoOrigem = "";
  String estacaoDestino = "";
  DateTime? startTime;
  DateTime? endTime;

  void selectOrigin(String station) {
    estacaoOrigem = station;
    if (estacaoDestino == station) estacaoDestino = "";
    notifyListeners();
  }

  void selectDestination(String station) {
    estacaoDestino = station;
    notifyListeners();
  }

  void selectStartTime(DateTime time) {
    startTime = time;
    notifyListeners();
  }

  void selectEndTime(DateTime time) {
    endTime = time;
    notifyListeners();
  }
}

class HomeScaffold extends StatefulWidget {
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
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
    return Scaffold(
      appBar: AppBar(
          title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Aplicação de Recomendação de Carruagens', style: TextStyle(fontWeight: FontWeight.bold),))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff125425)),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Optional: If you want to navigate to HomeScreen or refresh it
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HistoryScreen()));
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
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> stations = [];
  bool isLoadingStations = true;
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    final fetchedStations = await firebaseService.fetchAllStations();
    setState(() {
      stations = fetchedStations;
      isLoadingStations = false;
    });
  }

  void _onConfirm() async {
    final appState = context.read<MyAppState>();
    final origem = appState.estacaoOrigem;
    final destino = appState.estacaoDestino;
    final partidaPicked = appState.startTime;
    final chegadaPicked = appState.endTime;

    // 1) Validate stations
    if (origem.isEmpty || destino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecione ambas as estações de origem e destino')),
      );
      return;
    }
    if (origem == destino) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Estação de origem e destino não podem ser iguais')),
      );
      return;
    }

    // 2) Validate at least one time
    if (partidaPicked == null && chegadaPicked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Selecione pelo menos uma hora (partida ou chegada)')),
      );
      return;
    }
    // 3) If both times picked, ensure partida < chegada
    if (partidaPicked != null && chegadaPicked != null) {
      final sMin = partidaPicked.hour * 60 + partidaPicked.minute;
      final eMin = chegadaPicked.hour * 60 + chegadaPicked.minute;
      if (sMin >= eMin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Hora de partida deve ser antes da hora de chegada')),
        );
        return;
      }
    }

    // 4) Fetch station-filtered trains
    final stationFiltered =
        await firebaseService.fetchComboiosWithStations(origem, destino);
    if (stationFiltered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nenhum comboio encontrado para esta rota')),
      );
      return;
    }

    // 5) Filter by time windows
    final filtered = firebaseService.filterComboiosByTime(
      stationFiltered,
      partidaPicked,
      chegadaPicked,
      origem,
      destino,
    );
    if (filtered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nenhum comboio no intervalo selecionado')),
      );
      return;
    }

    // 6) Save to history if user logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .add({
        'origem': origem,
        'destino': destino,
        'startTime': partidaPicked?.toIso8601String(),
        'endTime': chegadaPicked?.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    // 7) Navigate to details
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => DetailScreen(
                comboios: filtered,
                partidaPicked: partidaPicked,
                chegadaPicked: chegadaPicked,
                selectedOrigem: origem,
                selectedDestino: destino,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    if (isLoadingStations) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StationSelector(
              selectedOrigin: appState.estacaoOrigem,
              selectedDestination: appState.estacaoDestino,
              onOriginChanged: appState.selectOrigin,
              onDestinationChanged: appState.selectDestination,
              stations: stations,
            ),
            const SizedBox(height: 24),
            TimePickers(
              startTime: appState.startTime,
              endTime: appState.endTime,
              onStartTimeChanged: appState.selectStartTime,
              onEndTimeChanged: appState.selectEndTime,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onConfirm,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff125425),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Ver Comboios'),
            ),
          ],
        ),
      ),
    );
  }
}
