import 'package:flutter/material.dart';

class DynamicCategories extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCategoriesChanged;

  const DynamicCategories({super.key, required this.onCategoriesChanged});

  @override
  State<DynamicCategories> createState() => _DynamicCategoriesState();
}

class _DynamicCategoriesState extends State<DynamicCategories> {
  // Liste des catégories
  final List<Map<String, dynamic>> categories = [
    {"title": "Jouets", "fields": ["Âge", "Marque"]},
    {"title": "Voitures", "fields": ["Marque", "Année", "Modèle"]},
  ];

  // Ajouter une nouvelle catégorie
  void _addCategory() {
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter une catégorie"),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(hintText: "Nom de la catégorie"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                categories.add({"title": categoryController.text, "fields": []});
              });
              widget.onCategoriesChanged(categories); // Callback
              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  // Modifier les champs d'une catégorie
  void _editCategoryFields(Map<String, dynamic> category) {
    TextEditingController fieldController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                "Champs pour ${category['title']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: category["fields"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(category["fields"][index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          category["fields"].removeAt(index);
                        });
                        widget.onCategoriesChanged(categories); // Callback
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: fieldController,
                  decoration:
                      const InputDecoration(labelText: "Nouveau champ"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    category["fields"].add(fieldController.text);
                  });
                  widget.onCategoriesChanged(categories); // Callback
                  fieldController.clear();
                },
                child: const Text("Ajouter champ"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          // Bouton pour ajouter une catégorie
          return GestureDetector(
            onTap: _addCategory,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          );
        }

        // Carte pour une catégorie
        final category = categories[index];
        return GestureDetector(
          onTap: () => _editCategoryFields(category),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                category["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
