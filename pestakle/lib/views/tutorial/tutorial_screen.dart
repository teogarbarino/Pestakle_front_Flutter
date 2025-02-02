import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Exemple de données pour le tutoriel : titre, description et image.
  final List<Map<String, String>> _tutorialData = [
    {
      'title': 'Bienvenue',
      'description':
          'Bienvenue sur notre application ! Découvrez ses fonctionnalités pas à pas.',
      'image': 'assets/images/tutorial1.png',
    },
    {
      'title': 'Navigation intuitive',
      'description':
          'Naviguez facilement grâce à une interface claire et conviviale.',
      'image': 'assets/images/tutorial2.png',
    },
    {
      'title': 'Prêt à commencer ?',
      'description':
          'Appuyez sur le bouton "Commencer" pour profiter de l\'expérience.',
      'image': 'assets/images/tutorial3.png',
    },
  ];

  int get _numPages => _tutorialData.length;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _numPages,
        (index) => _indicator(index == _currentPage),
      ),
    );
  }

  /// Affiche un popup proposant deux choix :
  /// - Créer un produit directement (route '/createProduct')
  /// - Aller sur la page principale (route '/main')
  void _finishTutorial() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Que souhaitez-vous faire ?"),
          content: const Text(
            "Voulez-vous créer un produit directement ou aller sur la page principale ?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Remplacez '/createProduct' par la route correspondant à la création d'un produit.
                Navigator.pushReplacementNamed(context, '/createProduct');
              },
              child: const Text("Créer un produit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text("Page principale"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bouton "Passer" dans l'AppBar pour quitter le tutoriel immédiatement
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishTutorial,
            child: const Text(
              'Passer',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _numPages,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final data = _tutorialData[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Affichage de l'image (vérifiez que le chemin est bien configuré dans pubspec.yaml)
                        Expanded(
                          child: Image.asset(
                            data['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['description']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildPageIndicator(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == _numPages - 1) {
                    _finishTutorial();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  _currentPage == _numPages - 1 ? 'Commencer' : 'Suivant',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
