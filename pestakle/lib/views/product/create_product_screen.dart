import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pestakle/controllers/service/https_service.dart';
import 'package:pestakle/global/route.dart';

class CreateProduitsScreen extends StatefulWidget {
  const CreateProduitsScreen({super.key});

  @override
  State<CreateProduitsScreen> createState() => _CreateProduitsScreenState();
}

class _CreateProduitsScreenState extends State<CreateProduitsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _colorsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // MultiSelect pour les catégories et les marques
  List<String> _selectedCategories = [];
  List<String> _selectedBrands = [];

  // Items initiaux pour catégories (exemple – à adapter)
  List<MultiSelectItem<String>> _categoryItems = [
    MultiSelectItem('clothing', 'Clothing'),
    MultiSelectItem('toy', 'Toy'),
    MultiSelectItem('accessory', 'Accessory'),
  ];
  // Items pour les marques (peuvent être récupérées via API ou définies statiquement)
  List<MultiSelectItem<String>> _brandItems = [];

  // Liste pour stocker plusieurs images encodées en base64
  List<String> _imagesBase64 = [];

  // Méthode de livraison : "livraison" ou "remise_en_main_propre"
  String? _deliveryMethod = "livraison"; // valeur par défaut

  bool _isLoading = false;

  /// Sélectionne une image depuis la galerie et l'ajoute à la liste
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imagesBase64.add(base64Encode(bytes));
      });
    }
  }

  /// Déplace l'image à l'index donné vers la gauche (si possible)
  void _moveImageLeft(int index) {
    if (index <= 0) return;
    setState(() {
      final temp = _imagesBase64[index - 1];
      _imagesBase64[index - 1] = _imagesBase64[index];
      _imagesBase64[index] = temp;
    });
  }

  /// Déplace l'image à l'index donné vers la droite (si possible)
  void _moveImageRight(int index) {
    if (index >= _imagesBase64.length - 1) return;
    setState(() {
      final temp = _imagesBase64[index + 1];
      _imagesBase64[index + 1] = _imagesBase64[index];
      _imagesBase64[index] = temp;
    });
  }

  /// Supprime l'image à l'index donné
  void _removeImage(int index) {
    setState(() {
      _imagesBase64.removeAt(index);
    });
  }

  /// Affiche une boîte de dialogue pour ajouter une nouvelle catégorie
  Future<void> _addNewCategory() async {
    String newCategory = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Category Name",
            ),
            onChanged: (value) {
              newCategory = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    if (newCategory.isNotEmpty) {
      if (!_categoryItems.any((item) => item.value == newCategory)) {
        setState(() {
          _categoryItems.add(MultiSelectItem(newCategory, newCategory));
          _selectedCategories.add(newCategory);
        });
      } else if (!_selectedCategories.contains(newCategory)) {
        setState(() {
          _selectedCategories.add(newCategory);
        });
      }
    }
  }

  /// Affiche une boîte de dialogue pour ajouter une nouvelle marque
  Future<void> _addNewBrand() async {
    String newBrand = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Brand"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Brand Name",
            ),
            onChanged: (value) {
              newBrand = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    if (newBrand.isNotEmpty) {
      if (!_brandItems.any((item) => item.value == newBrand)) {
        setState(() {
          _brandItems.add(MultiSelectItem(newBrand, newBrand));
          _selectedBrands.add(newBrand);
        });
      } else if (!_selectedBrands.contains(newBrand)) {
        setState(() {
          _selectedBrands.add(newBrand);
        });
      }
    }
  }

  /// Soumet le formulaire pour créer le produit
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // Construction du JSON en fonction de votre schéma côté serveur.
    // Note : Si votre schéma attend des chaînes pour "category" et "brand",
    // vous pouvez envoyer le premier élément des listes sélectionnées.
    Map<String, dynamic> postData = {
      "price": double.tryParse(_priceController.text) ?? 0.0,
      "categories": _selectedCategories,
      "brands": _selectedBrands,
      "size": _sizeController.text,
      "materials": _materialsController.text,
      "colors": _colorsController.text,
      "description": _descriptionController.text,
      "photos": _imagesBase64,
      // Ajout du champ pour la méthode de livraison
      "deliveryMethod":
          _deliveryMethod, // "livraison" ou "remise_en_main_propre"
    };

    final jsonString = jsonEncode(postData);
    inspect(jsonString);

    try {
      final response = await HttpService().makePostRequestWithToken(
        uPostPost,
        jsonString,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Error creating product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating product')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _sizeController.dispose();
    _materialsController.dispose();
    _colorsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Champ Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // MultiSelect pour les catégories
                MultiSelectDialogField<String>(
                  items: _categoryItems,
                  title: const Text("Categories"),
                  buttonText: const Text("Select Categories"),
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
                TextButton.icon(
                  onPressed: _addNewCategory,
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Category"),
                ),
                const SizedBox(height: 16),
                // MultiSelect pour les marques
                MultiSelectDialogField<String>(
                  items: _brandItems,
                  title: const Text("Brands"),
                  buttonText: const Text("Select Brands"),
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
                TextButton.icon(
                  onPressed: _addNewBrand,
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Brand"),
                ),
                const SizedBox(height: 16),
                // Champs optionnels : Size, Materials, Colors
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Size (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _materialsController,
                  decoration: const InputDecoration(
                    labelText: 'Materials (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _colorsController,
                  decoration: const InputDecoration(
                    labelText: 'Colors (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Champ Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Champ pour choisir la méthode de livraison
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Method:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<String>(
                      title: const Text("Livraison"),
                      value: "livraison",
                      groupValue: _deliveryMethod,
                      onChanged: (value) {
                        setState(() {
                          _deliveryMethod = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Remise en main propre"),
                      value: "remise_en_main_propre",
                      groupValue: _deliveryMethod,
                      onChanged: (value) {
                        setState(() {
                          _deliveryMethod = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Affichage des images sélectionnées dans une vue défilante horizontalement
                if (_imagesBase64.isNotEmpty)
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagesBase64.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        base64Decode(_imagesBase64[index])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_left),
                                    iconSize: 24,
                                    onPressed: index > 0
                                        ? () => _moveImageLeft(index)
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    iconSize: 20,
                                    onPressed: () => _removeImage(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_right),
                                    iconSize: 24,
                                    onPressed: index < _imagesBase64.length - 1
                                        ? () => _moveImageRight(index)
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                // Bouton pour sélectionner une nouvelle image
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image'),
                ),
                const SizedBox(height: 24),
                // Bouton de soumission
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
