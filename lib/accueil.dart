import 'package:flutter/material.dart';
import 'acheter.dart'; // Assure-toi que le nom du fichier est correct

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final List<Map<String, String>> plats = [
    {'nom': 'Atassi', 'image': 'asset/image/im7.jpeg'},
    {'nom': 'Spaghetti', 'image': 'asset/image/im2.jpeg'},
    {'nom': 'Couscous', 'image': 'asset/image/im8.jpeg'},
    {'nom': 'Piron', 'image': 'asset/image/im3.jpeg'},
    {'nom': 'Haricots', 'image': 'asset/image/im6.jpeg'},
    {'nom': 'Riz au gras', 'image': 'asset/image/im4.jpeg'},
    {'nom': 'Pâte rouge', 'image': 'asset/image/im9.jpeg'},
    {'nom': 'Thé', 'image': 'asset/image/im1.jpeg'},
    {'nom': 'Akassa', 'image': 'asset/image/im5.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text("RESTAU U DE L'UAC",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Désormais, achetez vos tickets en un clic !",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              itemCount: plats.length,
              itemBuilder: (context, index) {
                final plat = plats[index];
                return _buildFoodCard(plat['nom'] ?? 'Plat', plat['image'] ?? '');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                // Navigation vers la page d'achat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketSelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Acheter un ticket"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(String nom, String imagePath) {
    return Column(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.pink, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.fastfood, color: Colors.pink, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}