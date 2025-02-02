import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';
import 'package:pestakle/models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleur pour le nom
  final TextEditingController _nameController = TextEditingController();

  // Dropdowns
  String? selectedAgeRange;
  String? selectedProductCondition;

  // Sélections pour catégories et marques (List<String>)
  List<String> _selectedCategories = [];
  List<String> _selectedBrands = [];

  // Liste des catégories initiales (ici, statique)
  List<MultiSelectItem<String>> _categoryItems = [
    MultiSelectItem('Electroménager', 'Electroménager'),
    MultiSelectItem('Mobilier', 'Mobilier'),
    MultiSelectItem('Vêtements', 'Vêtements'),
    // Vous pouvez ajouter d'autres catégories initiales
  ];

  // Liste des marques récupérées (ou initialisées) via API
  List<MultiSelectItem<String>> _brandItems = [];

  // Options pour les dropdowns
  final List<String> ageRanges = ['0-3', '3-6', '6-9', '9-12'];
  final List<String> productConditions = ['neuf', 'occasion', 'mauvais état'];

  // Mode édition ou création
  bool _isEditMode = false;
  bool _didSetData = false;
  String profileId = "";

  @override
  void initState() {
    super.initState();
    _fetchBrandList();
  }

  /// Récupère la liste des marques depuis votre API
  Future<void> _fetchBrandList() async {
    try {
      final response = await http.get(
        Uri.parse('https://votre-api.com/api/brands'),
      );
      if (response.statusCode == 200) {
        List<dynamic> brandsJson = json.decode(response.body);
        List<String> brands = brandsJson.map((b) => b.toString()).toList();
        setState(() {
          _brandItems = brands
              .map((brand) => MultiSelectItem<String>(brand, brand))
              .toList();
        });
      } else {
        debugPrint('Erreur lors du chargement des marques');
      }
    } catch (e) {
      debugPrint('Exception lors de la récupération des marques: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didSetData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('profile')) {
        final UserProfile profile = args['profile'] as UserProfile;
        _isEditMode = true;
        profileId = profile.id;
        _nameController.text = profile.name;
        selectedAgeRange = profile.ageRange;
        selectedProductCondition = profile.productCondition;
        _selectedCategories = profile.categories ?? [];
        _selectedBrands = profile.brands ?? [];
      } else {
        _isEditMode = false;
      }
      _didSetData = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Affiche une boîte de dialogue pour ajouter une nouvelle marque.
  Future<void> _addNewBrand() async {
    String newBrand = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle marque"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Nom de la marque",
            ),
            onChanged: (value) {
              newBrand = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );

    if (newBrand.isNotEmpty) {
      // Ajout de la nouvelle marque à la liste si elle n'existe pas déjà.
      if (!_brandItems.any((item) => item.value == newBrand)) {
        setState(() {
          _brandItems.add(MultiSelectItem<String>(newBrand, newBrand));
          _selectedBrands.add(newBrand);
        });
      } else if (!_selectedBrands.contains(newBrand)) {
        // Si elle existe déjà, on s'assure qu'elle est sélectionnée.
        setState(() {
          _selectedBrands.add(newBrand);
        });
      }
    }
  }

  /// Affiche une boîte de dialogue pour ajouter une nouvelle catégorie.
  Future<void> _addNewCategory() async {
    String newCategory = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une nouvelle catégorie"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Nom de la catégorie",
            ),
            onChanged: (value) {
              newCategory = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );

    if (newCategory.isNotEmpty) {
      // Ajout de la nouvelle catégorie à la liste si elle n'existe pas déjà.
      if (!_categoryItems.any((item) => item.value == newCategory)) {
        setState(() {
          _categoryItems.add(MultiSelectItem<String>(newCategory, newCategory));
          _selectedCategories.add(newCategory);
        });
      } else if (!_selectedCategories.contains(newCategory)) {
        // Si elle existe déjà, on s'assure qu'elle est sélectionnée.
        setState(() {
          _selectedCategories.add(newCategory);
        });
      }
    }
  }

  /// Soumission du formulaire pour création ou mise à jour
  Future<void> _submitForm() async {
    if (!_isEditMode) {
      // Mode création : création du profil puis redirection vers la page tutoriel

      Navigator.pushReplacementNamed(context, '/tutorial');
    }
    /*
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Map<String, dynamic> profileData = {
        'name': _nameController.text,
        'ageRange': selectedAgeRange,
        'productCondition': selectedProductCondition,
        'categories': _selectedCategories,
        'brands': _selectedBrands,
      };

      final jsonString = jsonEncode(profileData);

      if (!_isEditMode) {
        var response = await HttpService()
            .makePostRequestWithoutToken(uPostCreateProfile, jsonString);
        if (response.statusCode == 201) {
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorDialog(
              "La création du profil a échoué. Veuillez réessayer.");
        }
      } else {
        var response = await HttpService().makePutRequestWithoutToken(
            '$uPostCreateProfile/$profileId', jsonString);
        if (response.statusCode == 200) {
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorDialog(
              "La mise à jour du profil a échoué. Veuillez réessayer.");
        }
      }
    } */
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Modifier le Profil" : "Créer un Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Champ Nom
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nom *'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Dropdown Tranche d'âge
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: "Tranche d'âge *"),
                    value: selectedAgeRange,
                    items: ageRanges
                        .map(
                          (age) => DropdownMenuItem(
                            value: age,
                            child: Text(age),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAgeRange = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une tranche d\'âge';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Dropdown État du produit
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: "État du produit *"),
                    value: selectedProductCondition,
                    items: productConditions
                        .map(
                          (cond) => DropdownMenuItem(
                            value: cond,
                            child: Text(cond),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProductCondition = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner un état';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Multi-select pour les catégories
                  MultiSelectDialogField<String>(
                    items: _categoryItems,
                    title: const Text("Catégories"),
                    buttonText: const Text("Sélectionnez des catégories"),
                    searchable: true,
                    initialValue: _selectedCategories,
                    onConfirm: (values) {
                      setState(() {
                        _selectedCategories = values;
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      onTap: (item) {
                        setState(() {
                          _selectedCategories.remove(item);
                        });
                      },
                    ),
                  ),
                  // Bouton pour ajouter une nouvelle catégorie si elle n'existe pas dans la liste
                  TextButton.icon(
                    onPressed: _addNewCategory,
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter une nouvelle catégorie"),
                  ),
                  const SizedBox(height: 16.0),
                  // Multi-select pour les marques
                  MultiSelectDialogField<String>(
                    items: _brandItems,
                    title: const Text("Marques"),
                    buttonText: const Text("Sélectionnez des marques"),
                    searchable: true,
                    initialValue: _selectedBrands,
                    onConfirm: (values) {
                      setState(() {
                        _selectedBrands = values;
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      onTap: (item) {
                        setState(() {
                          _selectedBrands.remove(item);
                        });
                      },
                    ),
                  ),
                  // Bouton pour ajouter une nouvelle marque
                  TextButton.icon(
                    onPressed: _addNewBrand,
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter une nouvelle marque"),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditMode
                        ? "Mettre à jour le profil"
                        : "Créer le profil"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
