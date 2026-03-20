import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketGenerePage extends StatelessWidget {
  final String? typeTicket;
  final String? ticketId;
  final String? dateAchat;
  final int? prix; // Reçoit le prix final pour affichage

  const TicketGenerePage({
    super.key,
    this.typeTicket,
    this.ticketId,
    this.dateAchat,
    this.prix, // Ajouté ici
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Mon Ticket Restau U"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "UNIVERSITÉ D'ABOMEY-CALAVI",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildInfoRow("Type de Repas", typeTicket ?? "Non spécifié"),
                      _buildInfoRow("Montant Payé", "${prix ?? 0} F CFA"), // Ligne du prix
                      _buildInfoRow("Date d'Achat", dateAchat ?? "Inconnue"),
                      const SizedBox(height: 25),
                      QrImageView(
                        data: ticketId ?? "ID_VIDE",
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "ID Ticket : ${ticketId ?? 'En attente'}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Présentez ce code au guichet du restaurant\npour valider votre repas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home),
                  label: const Text("Retour à l'accueil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}