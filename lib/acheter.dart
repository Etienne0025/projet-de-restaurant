import 'package:flutter/material.dart';
import 'effectuepaiement.dart';

class TicketSelectionPage extends StatefulWidget {
  const TicketSelectionPage({super.key});

  @override
  State<TicketSelectionPage> createState() => _TicketSelectionPageState();
}

class _TicketSelectionPageState extends State<TicketSelectionPage> {
  String? selectedTicket = 'Matin';

  // Fonction pour obtenir le prix selon le type
  int getPrix(String? type) {
    if (type == 'Matin') return 75;
    if (type == 'Midi' || type == 'Soir') return 150;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFDADA), Colors.white, Color(0xFFFFDADA)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "BIENVENUE AU RESTAU U DE L'UAC",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Choisir le type de ticket",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    _buildRadioOption("Matin", "75 F"),
                    _buildRadioOption("Midi", "150 F"),
                    _buildRadioOption("Soir", "150 F"),
                    const SizedBox(height: 20),
                    Text(
                      "Total : ${getPrix(selectedTicket)} F CFA",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentForm(
                                typeTicket: selectedTicket,
                                prix: getPrix(selectedTicket), // Envoi du prix
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Acheter",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String prixLabel) {
    return RadioListTile<String>(
      title: Text("$title ($prixLabel)"),
      value: title,
      groupValue: selectedTicket,
      activeColor: Colors.red,
      onChanged: (String? value) {
        setState(() => selectedTicket = value);
      },
    );
  }
}