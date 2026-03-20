import 'package:flutter/material.dart';
import 'ticket.dart';

enum PaymentMethod { card, mobile }

class PaymentForm extends StatefulWidget {
  final String? typeTicket;
  final int? prix; // Reçoit le prix de acheter.dart

  const PaymentForm({super.key, this.typeTicket, this.prix});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _cardController = TextEditingController();
  final _phoneController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.card;
  String _selectedOperator = 'MTN';

  @override
  void dispose() {
    _cardController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finaliser le paiement'),
        centerTitle: true,
        backgroundColor: Colors.red[50],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            "Récapitulatif : Ticket ${widget.typeTicket ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            "Montant à payer : ${widget.prix ?? 0} F CFA",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SegmentedButton<PaymentMethod>(
            segments: const [
              ButtonSegment(value: PaymentMethod.card, icon: Icon(Icons.credit_card), label: Text('Carte')),
              ButtonSegment(value: PaymentMethod.mobile, icon: Icon(Icons.phone_android), label: Text('Mobile')),
            ],
            selected: {_selectedMethod},
            onSelectionChanged: (selection) => setState(() => _selectedMethod = selection.first),
          ),
          const SizedBox(height: 24),
          if (_selectedMethod == PaymentMethod.card) _buildCardFields() else _buildMobileFields(),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketGenerePage(
                    typeTicket: widget.typeTicket,
                    prix: widget.prix, // Transmission du prix au ticket final
                    ticketId: "UAC-${DateTime.now().millisecondsSinceEpoch}",
                    dateAchat: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size.fromHeight(55),
            ),
            child: const Text('Confirmer le paiement'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFields() {
    return TextField(
      controller: _cardController,
      decoration: const InputDecoration(labelText: 'Numéro de carte', border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMobileFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedOperator,
          items: ['MTN', 'Moov', 'Celtis'].map((op) => DropdownMenuItem(value: op, child: Text(op))).toList(),
          onChanged: (val) => setState(() => _selectedOperator = val!),
          decoration: const InputDecoration(labelText: 'Opérateur', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Numéro de téléphone', border: OutlineInputBorder(), prefixText: '+229 '),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}