import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';

import 'package:pestakle/views/details_screen.dart';

class RandomBentoGrid extends StatefulWidget {
  const RandomBentoGrid({super.key});

  @override
  _RandomBentoGridState createState() => _RandomBentoGridState();
}

class _RandomBentoGridState extends State<RandomBentoGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();

  final List<Map<String, dynamic>> items = [];
  void _generateItemsWithAds() {
    int nextAdIndex =
        random.nextInt(26) + 5; // Compteur initial pour la première pub

    for (int i = 0; i < 100; i++) {
      // Ajoute une publicité à l'index défini
      if (i == nextAdIndex) {
        items.add({
          "type": "ad",
          "path": "assets/pub.gif", // Image de publicité
        });
        nextAdIndex +=
            random.nextInt(20) + 5; // Détermine l'index pour la prochaine pub
      }

      // Ajoute un élément normal
      items.add({
        "type": "item",
        "path": i % 3 == 0
            ? "assets/667logo.jpg"
            : (i % 3 == 1 ? "assets/wwow.gif" : "assets/zuukou-667.gif"),
        "userImage": "assets/kendrick.jpeg",
        "userName": "Zuukou 667",
        "brand": "Supreme",
        "condition": "Neuf",
        "sizeLabel": "L",
        "price": random.nextDouble() * 100 + 10,
        "shippingPrice": random.nextDouble() * 10 + 5,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateItemsWithAds();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    // Nombre de colonnes basé sur la largeur de l'écran
    final int crossAxisCount = screenWidth > 1200
        ? 6 // 6 colonnes pour les très grands écrans
        : (screenWidth > 800
            ? 4
            : 2); // 4 colonnes pour tablettes, 2 pour mobiles

    // Taille des cartes adaptée aux colonnes
    final List<double> cardHeights = [
      200.0 + 50.0 / crossAxisCount,
      250.0 + 50.0 / crossAxisCount,
      300.0 + 50.0 / crossAxisCount
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Bento Grid"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.count(
          crossAxisCount: crossAxisCount, // Nombre de colonnes dynamiques
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final double height =
                cardHeights[random.nextInt(cardHeights.length)];

            if (item["type"] == "ad") {
              return _buildAdCard(item["path"], height);
            } else {
              return _buildItemCard(item, height, context);
            }
          },
        ),
      ),
    );
  }
}

Widget _buildAdCard(String path, double height) {
  return SizedBox(
    height: height, // Taille fixe pour la publicité
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    ),
  );
}

class AnimatedGridItem extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const AnimatedGridItem({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

Widget _buildItemCard(Map<String, dynamic> item, height, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 1000), // Durée plus lente
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: DetailPage(item: item),
            );
          },
        ),
      );
    },
    child: SizedBox(
      height: height,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header avec l'utilisateur
            Flexible(
              flex: 2, // 20% de la hauteur totale pour le profil
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: height * 0.08,
                      backgroundImage: AssetImage(item["userImage"]),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item["userName"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Image ou GIF
            Flexible(
              flex: 6, // 60% de la hauteur totale pour l'image
              child: Hero(
                tag: "hero-${item['id']}",
                child: Image.asset(
                  item["path"],
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
            // Informations sur le produit
            Flexible(
              flex: 4, // 40% de la hauteur totale pour les informations
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item["brand"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "État : ${item["condition"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Taille :  ${item["sizeLabel"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${item["price"].toStringAsFixed(2)} €",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Livraison : ${item["shippingPrice"].toStringAsFixed(2)} €",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
