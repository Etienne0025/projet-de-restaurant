import 'package:flutter/material.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les données
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _matriculeController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AJOUT : Une AppBar transparente pour avoir le bouton retour en haut à gauche
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF880E4F)),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente (Login)
          },
        ),
      ),
      // On utilise extendBodyBehindAppBar pour que le contenu commence tout en haut
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Blanc/Rose avec ton logo UAC
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40), // Un peu plus d'espace pour l'AppBar
                    Image.asset(
                      'asset/image/uac.png',
                      height: 110,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.school, size: 80, color: Color(0xFF880E4F)),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField("Nom", _nomController),
                    _buildField("Prénoms", _prenomController),
                    _buildField("Matricule", _matriculeController),
                    _buildField("E-mail", _emailController,
                        keyboardType: TextInputType.emailAddress, isEmail: true),
                    _buildField("Mot de passe", _passController, isPassword: true),
                    _buildField("Confirmer Mot de passe", _confirmPassController,
                        isPassword: true, isConfirm: true),

                    const SizedBox(height: 30),

                    // Bouton S'inscrire
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Affiche le message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inscription réussie ! Redirection...'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // AJOUT : On attend 2 secondes puis on retourne au Login
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF880E4F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller,
      {bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
        bool isEmail = false,
        bool isConfirm = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _isObscure : false,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) return "Champ obligatoire";
          if (isEmail && !value.contains('@')) return "Email invalide";
          if (isConfirm && value != _passController.text)
            return "Mots de passe différents";
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _isObscure = !_isObscure),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}