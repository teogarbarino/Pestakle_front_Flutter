import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

// Modèle pour un filtre
class Filter {
  final String name; // Nom du filtre (par ex. "Brand")
  final String key; // Clé associée au produit (par ex. "brand")
  dynamic value; // Valeur du filtre
  bool isActive; // Indique si le filtre est actif

  Filter({
    required this.name,
    required this.key,
    this.value,
    this.isActive = false,
  });
}

class RandomBentoGrid extends StatefulWidget {
  const RandomBentoGrid({super.key});

  @override
  _RandomBentoGridState createState() => _RandomBentoGridState();
}

class _RandomBentoGridState extends State<RandomBentoGrid> {
  final Random random = Random();

  // Liste complète des éléments
  final List<Map<String, dynamic>> items = [];
  // Liste visible (après application de filtres/recherche)
  List<Map<String, dynamic>> visibleItems = [];

  // Liste des filtres dynamiques
  List<Filter> filters = [
    Filter(name: "Name contains 'a'", key: "userName"),
    Filter(name: "Brand: Supreme", key: "brand", value: "Supreme"),
    Filter(name: "Price Range: 50-100", key: "price", value: {"min": 50, "max": 100}),
    Filter(name: "Condition: New", key: "condition", value: "Neuf"),
  ];

  @override
  void initState() {
    super.initState();
    _generateItems();
    visibleItems = List.from(items); // Initialisation
  }

  // Générer une liste de données avec des champs aléatoires
  void _generateItems() {
    for (int i = 0; i < 50; i++) {
      items.add({
        "userName": _generateRandomString(8),
        "brand": i % 2 == 0 ? "Supreme" : "Nike",
        "price": random.nextDouble() * 100 + 10,
        "sizeLabel": i % 2 == 0 ? "M" : "L",
        "condition": i % 3 == 0 ? "Neuf" : "Usé",
        "path": "assets/667logo.jpg",
      });
    }
  }

  // Générer une chaîne aléatoire pour les noms
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Méthode pour afficher le BottomSheet avec les filtres et la création
  void _showFilterAndCreateSheet(BuildContext context) {
    TextEditingController categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filtres & Création de Catégories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // Liste des filtres existants
              Wrap(
                spacing: 8.0,
                children: filters.map((filter) {
                  return FilterChip(
                    label: Text(filter.name),
                    selected: filter.isActive,
                    onSelected: (selected) {
                      setState(() {
                        filter.isActive = selected;
                        _applyFilters();
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              // Champ pour ajouter une nouvelle catégorie
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Ajouter une catégorie",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              // Bouton pour ajouter la catégorie
              ElevatedButton(
                onPressed: () {
                  String categoryName = categoryController.text.trim();
                  if (categoryName.isNotEmpty) {
                    setState(() {
                      filters.add(Filter(name: categoryName, key: "custom"));
                    });
                    Navigator.pop(context); // Ferme le BottomSheet
                  }
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Méthode pour appliquer les filtres actifs
  void _applyFilters() {
    setState(() {
      visibleItems = items.where((item) {
        for (var filter in filters) {
          if (!filter.isActive) continue;

          if (filter.key == "userName" &&
              !(item[filter.key]?.toLowerCase().contains("a") ?? false)) {
            return false;
          }
          if (filter.key == "brand" && item[filter.key] != filter.value) {
            return false;
          }
          if (filter.key == "price") {
            final range = filter.value as Map<String, double>;
            if (item["price"] < range["min"]! || item["price"] > range["max"]!) {
              return false;
            }
          }
          if (filter.key == "condition" && item[filter.key] != filter.value) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final int crossAxisCount = screenWidth > 1200
        ? 6
        : (screenWidth > 800 ? 4 : 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Searchable Grid with Filters"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  visibleItems = items
                      .where((item) =>
                          item["userName"]?.toLowerCase().contains(query.toLowerCase()) ??
                          false)
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Liste des filtres
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: filters.map((filter) {
                return FilterChip(
                  label: Text(filter.name),
                  selected: filter.isActive,
                  onSelected: (selected) {
                    setState(() {
                      filter.isActive = selected;
                      _applyFilters();
                    });
                  },
                );
              }).toList(),
            ),
          ),
          // Grille des éléments
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterAndCreateSheet(context),
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  // Widget pour afficher un élément sous forme de carte
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Image.asset(
            item["path"],
            fit: BoxFit.cover,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User: ${item["userName"]}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Brand: ${item["brand"]}"),
                Text("Size: ${item["sizeLabel"]}"),
                Text("Price: ${item["price"].toStringAsFixed(2)} €"),
                Text("Condition: ${item["condition"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
