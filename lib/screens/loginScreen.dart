import 'package:flutter/material.dart';
import 'package:namer_app/screens/registerScreen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  const LoginScreen({Key? key, required this.onSignedIn}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoggedIn = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  void _logout() async {
    await _authService.logout();
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Preencha o email e a password";
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    try {
      final user = await _authService.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (user != null) {
        widget.onSignedIn();
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        errorMessage = "Login falhado: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoggedIn
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Utilizador já se encontra logged in."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                child: const Text("Log out"),
              ),
            ],
          ),
        )
            : Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            SizedBox(height: 12,),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            SizedBox(height: 12,),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                      onRegistered: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
