import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Firebase nur wenn verwendet
import '../main.dart' show USE_FIREBASE;
import 'package:firebase_auth/firebase_auth.dart' if (USE_FIREBASE) 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  dynamic _user;

  dynamic get user => _user;

  AuthProvider() {
    if (USE_FIREBASE) {
      // Firebase-Version
      final FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } else {
      // Demo-Version - automatisch eingeloggt
      _user = DemoUser(email: 'demo@recify.com', displayName: 'Demo User');
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    if (USE_FIREBASE) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } else {
      // Demo-Version - immer erfolgreich
      _user = DemoUser(email: email, displayName: 'Demo User');
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    if (USE_FIREBASE) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      // Demo-Version - immer erfolgreich
      _user = DemoUser(email: email, displayName: 'Demo User');
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    if (USE_FIREBASE) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
    } else {
      // Demo-Version - bleibt eingeloggt
      // Kann für Demo-Zwecke auskommentiert werden
    }
  }
}

// Demo User Klasse für Firebase-freie Version
class DemoUser {
  final String email;
  final String displayName;

  DemoUser({required this.email, required this.displayName});
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recify')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _authenticate,
                child: Text(_isSignUp ? 'Registrieren' : 'Anmelden'),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp
                    ? 'Bereits ein Konto? Anmelden'
                    : 'Noch kein Konto? Registrieren',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (_isSignUp) {
        await authProvider.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await authProvider.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
