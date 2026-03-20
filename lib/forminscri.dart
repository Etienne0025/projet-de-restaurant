import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'accueil.dart'; // Assurez-vous que ce fichier existe et exporte Accueil

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _matriculeController = TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _matriculeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    debugPrint('🚀 Début inscription - email: ${_emailController.text}');

    try {
      debugPrint('📝 Appel FirebaseAuth.createUserWithEmailAndPassword...');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('⏰ TIMEOUT Firebase Auth');
          throw TimeoutException(
              "Le serveur ne répond pas. Vérifiez votre connexion.");
        },
      );

      debugPrint('✅ Firebase Auth réussi - UID: ${userCredential.user?.uid}');

      debugPrint('💾 Écriture dans Firestore...');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'matricule': _matriculeController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('🎉 Firestore : écriture OK');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Compte créé avec succès !"),
          backgroundColor: Colors.green,
        ),
      );

      // Redirection vers la page d'accueil (sans const)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
      );
    } on TimeoutException catch (e) {
      debugPrint('❌ TimeoutException: $e');
      _showError(e.message ?? "Délai d'attente dépassé");
    } on FirebaseAuthException catch (e) {
      debugPrint('🔥 FirebaseAuthException: ${e.code} - ${e.message}');
      String message = "Erreur d'authentification";
      if (e.code == 'email-already-in-use') {
        message = "Cet email est déjà utilisé.";
      } else if (e.code == 'weak-password') {
        message = "Mot de passe trop faible (minimum 6 caractères).";
      } else if (e.code == 'invalid-email') {
        message = "L'email n'est pas valide.";
      } else {
        message = e.message ?? message;
      }
      _showError(message);
    } on FirebaseException catch (e) {
      debugPrint('🔥 Firestore Exception: ${e.message}');
      _showError("Erreur Firestore : ${e.message}");
    } catch (e, stack) {
      debugPrint('❌ Exception inattendue: $e');
      debugPrint(stack.toString());
      _showError("Une erreur s'est produite : $e");
    } finally {
      debugPrint('🏁 Fin _handleSignUp');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Créer votre compte étudiant",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _matriculeController,
                decoration: const InputDecoration(
                  labelText: 'N° Matricule',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Matricule requis' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email requis';
                  if (!value.contains('@') || !value.contains('.'))
                    return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(
                            () => _isObscurePassword = !_isObscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Mot de passe requis';
                  if (value.length < 6) return 'Minimum 6 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(
                            () => _isObscureConfirm = !_isObscureConfirm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Confirmation requise';
                  if (value != _passwordController.text)
                    return 'Les mots de passe ne correspondent pas';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}