import 'package:flutter/material.dart';

class CounterOfferScreen extends StatefulWidget {
  const CounterOfferScreen({Key? key}) : super(key: key);

  @override
  _CounterOfferScreenState createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends State<CounterOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitCounterOffer() {
    if (_formKey.currentState?.validate() ?? false) {
      final double offerPrice = double.parse(_offerController.text);
      final String message = _messageController.text.trim();

      // Vous pouvez ici intégrer la logique pour envoyer la contre‑offre à votre backend.
      print("Nouvelle contre‑offre : $offerPrice €");
      print("Message associé : $message");

      // Fermer l'écran et renvoyer le résultat à l'écran appelant
      Navigator.pop(context, {
        "counterOffer": offerPrice,
        "message": message,
      });
    }
  }

  @override
  void dispose() {
    _offerController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une contre‑offre"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ pour saisir le nouveau prix
              TextFormField(
                controller: _offerController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Nouveau prix proposé (€)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un prix";
                  }
                  if (double.tryParse(value) == null) {
                    return "Veuillez entrer un nombre valide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Champ facultatif pour ajouter un message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: "Message (optionnel)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitCounterOffer,
                    child: const Text("Envoyer"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Annuler"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
