import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pestakle/components/dynamicCategorie.dart';
import 'dart:math';

import 'package:pestakle/views/details_screen.dart';

// Enum pour définir les filtres disponibles
enum FilterType { userName, brand, priceRange, condition }

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

  // Map pour gérer l'état actif des filtres
  Map<FilterType, bool> activeFilters = {
    FilterType.userName: false,
    FilterType.brand: false,
    FilterType.priceRange: false,
    FilterType.condition: false,
  };

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

  // Appliquer les filtres actifs
  void _applyFilters() {
    setState(() {
      visibleItems = items.where((item) {
        if (activeFilters[FilterType.userName]! &&
            !(item["userName"]?.toLowerCase().contains("a") ?? false)) {
          return false;
        }
        if (activeFilters[FilterType.brand]! &&
            item["brand"] != "Supreme") return false;
        if (activeFilters[FilterType.priceRange]! &&
            (item["price"] < 50 || item["price"] > 100)) return false;
        if (activeFilters[FilterType.condition]! &&
            item["condition"] != "Neuf") return false;
        return true;
      }).toList();
    });
  }

  // Basculer l'état d'un filtre
  void _toggleFilter(FilterType filter) {
    setState(() {
      activeFilters[filter] = !activeFilters[filter]!;
      _applyFilters();
    });
  }

  // Filtrer les éléments en fonction de la recherche
  void _filterItems(String query) {
    setState(() {
      visibleItems = items.where((item) {
        final userNameMatch = item["userName"]
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
        return userNameMatch;
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
              onChanged: _filterItems, // Filtrer lors de la saisie
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Filtres dynamiques
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  child: SizedBox(
    height: 100, // Hauteur pour les catégories dynamiques
    child: DynamicCategories(
     onCategoriesChanged: (filters) {
  setState(() {
    visibleItems = items.where((item) {
      if ((filters[FilterType.userName.index] ?? false) &&
          !(item["userName"]?.contains('a') ?? false)) {
        return false;
      }
      if ((filters[FilterType.brand.index] ?? false) &&
          item["brand"] != "Supreme") {
        return false;
      }
      if ((filters[FilterType.priceRange.index] ?? false) &&
          (item["price"] < 50 || item["price"] > 100)) {
        return false;
      }
      if ((filters[FilterType.condition.index] ?? false) &&
          item["condition"] != "Neuf") {
        return false;
      }
      return true;
    }).toList();
  });
},
    ),
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
                return GestureDetector(onTap: () {
    // Navigue vers la page de détail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: item),
      ),
    );
  },
  onLongPress: (){
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            item["path"],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  },
                  child: _buildItemCard(item));
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher les filtres sous forme de chips
  Widget _buildFilterChip(FilterType filter, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: activeFilters[filter]!,
      onSelected: (_) => _toggleFilter(filter),
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[200],
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
