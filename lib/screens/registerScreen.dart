import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegistered;

  const RegisterScreen({Key? key, required this.onRegistered}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errorMessage;

  void _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = "Preencha todos os campos.";
      });
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = "As passwords não coincidem.";
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    try {
      final user = await _authService.registerWithEmail(
          _emailController.text.trim(), _passwordController.text);
      if (user != null) {
        widget.onRegistered();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen(onSignedIn: () {  },)),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = "Registo falhado: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: "Confirmar Password"), obscureText: true),
            if (errorMessage != null) Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            SizedBox(height: 12,),
            ElevatedButton(onPressed: _register, child: const Text("Registar")),
          ],
        ),
      ),
    );
  }
}
