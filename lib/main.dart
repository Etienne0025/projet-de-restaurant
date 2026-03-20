import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'firebase_options.dart';

// Tes imports
import 'forminscri.dart';
import 'motdepasseoublie.dart';
import 'accueil.dart'; // Ce fichier contient la classe Accueil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Erreur d'initialisation Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant UAC',
      theme: ThemeData(
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.pink),
      ),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .timeout(const Duration(seconds: 15));

      if (!_isMounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      // CORRECTION ICI : Utilisation du nom de classe "Accueil" et retrait du "const"
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accueil()),
      );
    } on FirebaseAuthException catch (e) {
      if (!_isMounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showSnackBar(e.message ?? "Erreur de connexion", Colors.red);
    } catch (e) {
      if (!_isMounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showSnackBar("Erreur : $e", Colors.grey);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'asset/image/uac.png',
                  height: 120,
                  errorBuilder: (c, e, s) => const Icon(Icons.school, size: 80, color: Colors.pink),
                ),
                const SizedBox(height: 30),
                const Text("Connexion Restaurant UAC",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.pink),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.pink),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Trop court' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Se connecter"),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const InscriptionPage())),
                  child: const Text("Créer un compte", style: TextStyle(color: Colors.pink)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}