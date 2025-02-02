import 'package:flutter/material.dart';

class SearchableList<T> extends StatefulWidget {
  final List<T> data; // Liste complète des données
  final String Function(T)
      searchField; // Fonction pour extraire le champ à rechercher
  final void Function(List<T>)
      onSearch; // Callback pour renvoyer les résultats filtrés
  final String placeholder; // Texte de l'input de recherche

  const SearchableList({
    super.key,
    required this.data,
    required this.searchField,
    required this.onSearch,
    this.placeholder = 'Search...',
  });

  @override
  _SearchableListState<T> createState() => _SearchableListState<T>();
}

class _SearchableListState<T> extends State<SearchableList<T>> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          query = value;
        });
        final filteredData = widget.data.where((item) {
          final searchText = widget.searchField(item).toLowerCase();
          return searchText.contains(value.toLowerCase());
        }).toList();
        widget.onSearch(filteredData);
      },
      decoration: InputDecoration(
        hintText: widget.placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
