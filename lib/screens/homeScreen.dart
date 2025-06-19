import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Comboio.dart';
import '../screens/CarriageDetailScreen.dart';
import '../services/auth_service.dart';
import 'historyScreen.dart';
import 'loginScreen.dart';
import 'package:awesome_datetime_picker/awesome_datetime_picker.dart';


class MyAppState extends ChangeNotifier {
  String estacaoOrigem = "";
  String estacaoDestino = "";

  List<String> get obterEstacoesLinhaSintras =>
      Comboio.obterEstacoesLinhaSintra();

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
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
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
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryScreen()),
                );
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


class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  DateTime? startTime;
  DateTime? endTime;
  final DateFormat hourFormat = DateFormat('HH:mm');

  Future<void> pickStartTime() async {
    AwesomeTime? pickedTime = AwesomeTime(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

    final result = await showDialog<AwesomeTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: 360,
            height: 200,
            child: AwesomeTimePicker(
              initialTime: pickedTime!,
              timeFormat: AwesomeTimeFormat.Hm,
              onChanged: (time) {
                pickedTime = time;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, pickedTime), // Confirm with pickedTime
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        startTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          result.hour,
          result.minute,
        );
      });
    }
  }




  Future<void> pickEndTime() async {
    AwesomeTime? pickedTime = AwesomeTime(
      hour: TimeOfDay.now().hour,
      minute: TimeOfDay.now().minute,
    );

    final result = await showDialog<AwesomeTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SizedBox(
            width: 360,
            height: 200,
            child: AwesomeTimePicker(
              initialTime: pickedTime!,
              timeFormat: AwesomeTimeFormat.Hm,
              onChanged: (time) {
                pickedTime = time;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, pickedTime), // Confirm with value
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          result.hour,
          result.minute,
        );
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Selecionar estação de origem:"),
          DropdownButton<String>(
            value: appState.estacaoOrigem.isNotEmpty ? appState.estacaoOrigem : null,
            hint: Text("Estação de Origem"),
            onChanged: (newValue) {
              if (newValue != null) appState.selectStation(newValue);
            },
            items: appState.obterEstacoesLinhaSintras.map((station) {
              return DropdownMenuItem(value: station, child: Text(station));
            }).toList(),
          ),
          SizedBox(height: 12),
          Text("Selecionar estação de destino:"),
          DropdownButton<String>(
            value: appState.estacaoDestino.isNotEmpty ? appState.estacaoDestino : null,
            hint: Text("Estação de Destino"),
            onChanged: (newValue) {
              if (newValue != null) appState.selectDestination(newValue);
            },
              items: appState.obterEstacoesLinhaSintras
                  .where((station) => station != appState.estacaoOrigem)
                  .map((station) => DropdownMenuItem(value: station, child: Text(station)))
                  .toList()

          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: pickStartTime,
            child: Text(
              startTime == null
                  ? "Selecionar hora início"
                  : "Início: ${hourFormat.format(startTime!)}",
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: pickEndTime,
            child: Text(
              endTime == null
                  ? "Selecionar hora fim"
                  : "Fim: ${hourFormat.format(endTime!)}",
            ),
          ),
          SizedBox(height: 32),
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
              if (startTime == null || endTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecione intervalo de horas.")),
                );
                return;
              }

              final sMin = startTime!.hour * 60 + startTime!.minute;
              final eMin = endTime!.hour * 60 + endTime!.minute;

              if (sMin >= eMin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Hora início deve ser antes da hora fim.")),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StationDetailPage(
                    nomeEstacaoOrigem: appState.estacaoOrigem,
                    nomeEstacaoDestino: appState.estacaoDestino,
                    startTime: TimeOfDay.fromDateTime(startTime!),
                    endTime: TimeOfDay.fromDateTime(endTime!),
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

