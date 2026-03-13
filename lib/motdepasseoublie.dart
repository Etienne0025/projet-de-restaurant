import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. L'enveloppe de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // 2. Contrôleur pour lire le texte de l'email
  final TextEditingController _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose(); // Toujours nettoyer les contrôleurs
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mot de passe oublié')),
      // Utilisation d'un SingleChildScrollView pour éviter les erreurs de pixels
      // quand le clavier apparaît
      body: SingleChildScrollView(
        child: _sent ? _buildSuccessState() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            'Entrez votre email de récupération.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController, // Liaison du contrôleur
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // Simulation d'envoi
              if (_emailController.text.isNotEmpty) {
                setState(() => _sent = true);
              }
            },
            child: const Text('Envoyer'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context), // Retour à la page précédente
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Icon(
              Icons.check_circle,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Vérifie ton email',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Nous avons envoyé un code à ${_emailController.text}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => setState(() => _sent = false),
              child: const Text('Essaie avec un autre email'),
            ),
          ],
        ),
      ),
    );
  }
}