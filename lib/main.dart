import 'package:flutter/material.dart';
import 'forminscri.dart';
import 'motdepasseoublie.dart';

void main() {
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
        primarySwatch: Colors.pink,
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
  // La clé est déclarée à l'intérieur du State pour être bien gérée par Flutter
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Rose très clair (pink[50])
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 1. Logo UAC
                Image.asset(
                  'asset/image/uac.png',
                  height: isSmallScreen ? 120 : 180,
                  fit: BoxFit.contain,
                  // Si l'image n'est pas trouvée, affiche une icône de secours
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.school, size: 100, color: Colors.pink);
                  },
                ),
                const SizedBox(height: 30),

                // 2. Champ Matricule (8 chiffres)
                _buildTextField(
                  label: 'Matricule',
                  icon: Icons.person_outline,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre matricule';
                    }
                    if (value.length != 8) {
                      return 'Le matricule doit faire 8 chiffres';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Uniquement des chiffres';
                    }
                    return null;
                  },
                ),

                // 3. Champ Mot de passe
                _buildTextField(
                  label: 'Mot de passe',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mot de passe requis';
                    }
                    return null;
                  },
                ),

                // 4. Mot de passe oublié
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 35.0, bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      // C'est ICI qu'on met la navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Mot de passe oublié',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ),
                ),

                // 5. Bouton S'inscrire
                _buildButton(
                  text: "S'inscrire",
                  isPrimary: true,
                  onPressed: () {
                    // Logique pour aller vers la page d'inscription
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InscriptionPage()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                // 6. Bouton Se connecter
                _buildButton(
                  text: "Se connecter",
                  isPrimary: false,
                  onPressed: () {
                    // Appel de la validation via la clé
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vérification du matricule...')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS PERSONNALISÉS (Logique de construction) ---

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: isNumber ? 8 : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          counterText: "", // Cache le compteur de caractères par défaut
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: isPrimary
          ? ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey, width: 1.5),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}